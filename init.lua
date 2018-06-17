--[[
    Mobs Humans - Adds human mobs.
    Copyright (C) 2018  Hamlet

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]


--
-- General variables
--

local minetest_log_level = minetest.settings:get("debug_log_level")
local mob_difficulty = tonumber(minetest.settings:get("mob_difficulty"))
if (mob_difficulty == nil) then
	 mob_difficulty = 1
end

local mod_load_message = "[Mod] Mobs Humans [v0.2.0-dev] loaded."


--
-- Functions
--

local function random_type()
	local type = "npc"
	local number = math.random(1, 20)

	if (number <= 10) then
		type = "monster"

	elseif (number >= 16) then
		type = "animal"
	end

	return type
end


local function random_damage()
	 local damage = (math.random(1, 8) * mob_difficulty)
	 return damage
end


local function random_armour()
	 local armour = math.random(10, 100)
	 return armour
end


local function heal_over_time(self, dtime)
	if (self.state ~= "attack") and (self.state ~= "runaway") then
		-- For backward compatibility
		if (self.heal_counter == nil) or (self.initial_hp == nil) then
			self.heal_counter = 4.0
			-- used for health recovery

			self.initial_hp = math.random(self.hp_min, self.hp_max)
			-- used as reference when recovering health

			self.object:set_properties({
				heal_counter = self.heal_counter,
				initial_hp = self.initial_hp
			})
		end

		-- recover 1HP every 4 seconds
		if (self.health < self.initial_hp)
		and (self.state ~= "attack")
		and (self.state ~= "runaway")
		then
			if (self.heal_counter > 0) then
				self.heal_counter = self.heal_counter - dtime

				self.object:set_properties({
					heal_counter = self.heal_counter
				})

			else
				self.heal_counter = 4.0
				self.health = self.health + 1
				self.object:set_hp(self.health)

				self.object:set_properties({
					heal_counter = self.heal_counter
				})

			end
		end
	end
end


local function combat_tag(self)
	if (self.attack)
	and (self.combat_nametag ~= true)
	then
		self.combat_nametag = true

		if self.attack:is_player() then
			self.foe = self.attack:get_player_name()

		else
			self.foe = self.attack:get_luaentity().given_name

			if (self.foe == nil) then
				self.foe = self.attack:get_luaentity().name
			end
		end

		if (self.given_name == nil) then
			self.given_name = random_string(math.random(2, 5))

			self.object:set_properties({given_name = self.given_name})
		end

		self.nametag = self.given_name .. " (" .. self.type .. ")\n" ..
			"Armor: " .. self.armor .. " - " ..
			"Damage: " .. self.damage ..
			"\nVs " .. self.foe

		self.object:set_properties({
			nametag = self.nametag,
			combat_nametag = self.combat_nametag
		})

	elseif (self.attack == nil)
	and (self.combat_nametag ~= false)
	then
		self.combat_nametag = false
		self.nametag = self.given_name .. "\n" ..
 			"(" .. self.type .. ")"

		self.object:set_properties({
			nametag = self.nametag,
			combat_nametag = self.combat_nametag
		})

	end
end


local function experience(self)
	if (self.attack == nil) and (self.engaged ~= true) then
		return

	elseif (self.attack ~= nil) and (self.engaged ~= true) then
		self.engaged = true

		self.object:set_properties({engaged = self.engaged})

	elseif (self.attack == nil) and (self.engaged == true) then
		self.engaged = false

		self.object:set_properties({engaged = self.engaged})

		if (self.damage < (8 * mob_difficulty)) then
			self.damage = self.damage + 1
			self.object:set_properties({damage = self.damage})
		end

		if (self.armor > 10) then
			self.armor = self.armor - 1
			self.object:set_properties({armor = self.armor})
		end
	end
end


local function random_string(length)

	local letter = 0
	local number = 0
	local initial_letter = true
	local string = ""
	local exchanger = ""
	local forced_choice = ""
	local vowels = {"a", "e", "i", "o", "u"}
	local semivowels = {"y", "w"}

	local simple_consonants = {
		"m", "n", "b", "p", "d", "t", "g", "k", "l", "r", "s", "z", "h"
	}

	local compound_consonants = {
		"ñ", "v", "f", "ð", "þ", "ɣ", "ħ", "ɫ", "ʃ", "ʒ"
	}

	local compound_consonants_uppercase = {
		"Ñ", "V", "F", "Ð", "Þ", "Ɣ", "Ħ", "Ɫ", "Ʃ", "Ʒ"
	}

	local double_consonants = {
		"mm", "mb", "mp", "mr", "ms", "mz", "mf",
		"mʃ",
		"nn", "nd", "nt", "ng", "nk", "nr", "ns", "nz",
		"nð", "nþ", "nɣ", "nħ", "nʃ", "nʒ",
		"bb", "bl", "br", "bz",
		"bʒ",
		"pp", "pl", "pr", "ps",
		"pʃ",
		"dd", "dl", "dr", "dz",
		"dʒ",
		"tt", "tl", "tr", "ts",
		"tʃ",
		"gg", "gl", "gr", "gz",
		"gʒ",
		"kk", "kl", "kr", "ks",
		"kʃ",
		"ll", "lm", "ln", "lb", "lp", "ld", "lt", "lg", "lk", "ls", "lz",
		"lñ", "lv", "lf", "lð", "lþ", "lɣ", "lħ", "lʃ", "lʒ",
		"rr", "rm", "rn", "rb", "rp", "rd", "rt", "rg", "rk", "rs", "rz",
		"rñ", "rv", "rf", "rð", "rþ", "rɣ", "rħ", "rʃ", "rʒ",
		"ss", "sp", "st", "sk",
		"sf",
		"zz", "zm", "zn", "zb", "zd", "zg", "zl", "zr",
		"zñ", "zv",
		"vl", "vr",
		"fl", "fr",
		"ðl", "ðr",
		"þl", "þr",
		"ɣl", "ɣr",
		"ħl", "ħr",
		"ʃp", "ʃt", "ʃk",
		"ʃf",
		"ʒm", "ʒn", "ʒb", "ʒd", "ʒg", "ʒl", "ʒr",
		"ʒv"
	}

	local double_consonants_uppercase = {
		"Bl", "Br", "Bz",
		"Bʒ",
		"Pl", "Pr", "Ps",
		"Pʃ",
		"Dl", "Dr", "Dz",
		"Dʒ",
		"Tl", "Tr", "Ts",
		"Tʃ",
		"Gl", "Gr", "Gz",
		"Gʒ",
		"Kl", "Kr", "Ks",
		"Kʃ",
		"Sp", "St", "Sk",
		"Sf",
		"Zm", "Zn", "Zb", "Zd", "Zg", "Zl", "Zr",
		"Zñ", "Zv",
		"Vl", "Vr",
		"Fl", "Fr",
		"Ðl", "Ðr",
		"Þl", "Þr",
		"Ɣl", "Ɣr",
		"Ħl", "Ħr",
		"Ʃp", "Ʃt", "Ʃk",
		"Ʃf",
		"Ʒm", "Ʒn", "Ʒb", "Ʒd", "Ʒg", "Ʒl", "Ʒr",
		"Ʒv"
	}

	local previous_letter = ""

	for initial_value = 1, length do

		letter = letter + 1

		local chosen_group = math.random(1, 5)

		if (exchanger == "vowel") then
			chosen_group = math.random(3, 5)

		elseif (exchanger == "semivowel") then
			chosen_group = 1

		elseif (exchanger == "simple consonant") then
			if (letter < length) then
				chosen_group = math.random(1, 2)
			else
				chosen_group = 1
			end

		elseif (exchanger == "compound consonant") then
			chosen_group = 1

		elseif (exchanger == "double consonant") then
			chosen_group = 1

		end


		if (chosen_group == 1) then

			if (initial_letter == true) then
				initial_letter = false
				number = math.random(1, 5)
				previous_letter = string.upper(vowels[number])
				string = string .. previous_letter

			else
				number = math.random(0, 1) -- single or double vowel

				if (number == 0) then
					number = math.random(1, 5)
					previous_letter = vowels[number]
					string = string .. previous_letter

				else
					number = math.random(1, 5)
					previous_letter = vowels[number]
					string = string .. previous_letter

					number = math.random(1, 5)
					previous_letter = vowels[number]
					string = string .. previous_letter

				end
			end

			exchanger = "vowel"


		elseif (chosen_group == 2) then

			number = math.random(1, 2)

			if (letter ~= 2) then
				if (initial_letter == true) then
					initial_letter = false
					previous_letter = string.upper(semivowels[number])
					string = string .. previous_letter
				else
					previous_letter = semivowels[number]
					string = string .. previous_letter

				end

				exchanger = "semivowel"

			elseif (letter == 2) then
				if (previous_letter == "L") or (previous_letter == "R")
				or (previous_letter == "Ɫ") or (previous_letter == "Y")
				or (previous_letter == "W") or (previous_letter == "H") then
					if (number == 1) then
						previous_letter = "i"
						string = string .. previous_letter

					elseif (number == 2) then
						previous_letter = "u"
						string = string .. previous_letter

					end
				end

				exchanger = "vowel"
			end


		elseif (chosen_group == 3) then

			number = math.random(1, 13)

			if (initial_letter == true) then
				initial_letter = false
				previous_letter = string.upper(simple_consonants[number])
				string = string .. previous_letter

			else
				previous_letter = simple_consonants[number]
				string = string .. previous_letter

			end

			exchanger = "simple consonant"


		elseif (chosen_group == 4) then

			number = math.random(1, 10)

			if (initial_letter == true) then
				initial_letter = false
				previous_letter = compound_consonants_uppercase[number]
				string = string .. previous_letter

			else
				previous_letter = compound_consonants[number]
				string = string .. previous_letter
			end

			exchanger = "compound consonant"


		elseif (chosen_group == 5) then

			if (initial_letter == true) then
				initial_letter = false
				number = math.random(1, 61)
				previous_letter = double_consonants_uppercase[number]
				string = string .. previous_letter

			else
				number = math.random(1, 131)
				previous_letter = double_consonants[number]
				string = string .. previous_letter
			end

			exchanger = "double consonant"

		end
	end

	initial_letter = true

	return string
end


--
-- Entity definition
--

mobs:register_mob("mobs_humans:human", {
	nametag = "",
	given_name = "",
	type = "",
	hp_min = 16,
	hp_max = 20,
	armor = 100,
	passive = false,
	walk_velocity = 4,
	run_velocity = 4,
	walk_chance = 1,
	jump = false,
	runaway = false,
	view_range = 15,
	damage = 1,
	water_damage = 2,
	lava_damage = 8,
	suffocation = true,
	floats = 1,
	reach = 4,
	attacks_monsters = true,
	attack_animals = true,
	group_attack = true,
	attack_type = "dogfight",
	specific_attack = {"player", "mobs_humans:human"},
	runaway_from = {
		"mobs_ghost_redo:ghost",
		"mobs_banshee:banshee",
		"mobs_others:snow_walker"
	},
	makes_footstep_sound = true,
	sounds = {
		attack = "default_punch"
	},
	visual = "mesh",
	visual_size = {x = 1, y = 1},
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.75, 0.4},
	selectionbox = {-0.4, -1, -0.4, 0.4, 0.75, 0.4},
	textures = {
		{"mobs_humans_female_01.png"},
		{"mobs_humans_female_02.png"},
		{"mobs_humans_male_01.png"},
		{"mobs_humans_male_02.png"}
	},
	mesh = "character.b3d",
	animation = {
		stand_start = 0,
		stand_end = 79,
		stand_speed = 30,
		walk_start = 168,
		walk_end = 187,
		walk_speed = 30,
		run_start = 168,
		run_end = 187,
		run_speed = 30,
		punch_start = 189,
		punch_end = 198,
		punch_speed = 30,
		die_start = 162,
		die_end = 166,
		die_speed = 0.8
	},
	replace_what = {
		"bones:bones"
	},
	replace_with = "air",
	replace_rate = 4,
	replace_offset = -2,

	-- Choose and set random appearence and stats:
	-- * type (animal, monster, npc)
	-- * walk chance (10 - 33; 10: unlikely, 33: probable)
	-- * armor (100 - 10; 100: normal, 10: strongest)
	-- * damage (1 - 8; 1: bare hands, 8: diamond sword)
	on_spawn = function(self, pos)
		self.armor = random_armour()
		self.object:set_armor_groups({
			immortal = 1,
			fleshy = self.armor
		})

		self.type = random_type()
		self.given_name = random_string(math.random(2, 5))
		self.damage = random_damage()
		self.walk_chance = math.random(10, 33)
		if (self.type == "animal") then
			self.passive = true
			self.runaway = true
			self.replace_what = {
				"mobs:cobweb",
				"fort_spikes:broken_wood_spikes",
				"fort_spikes:broken_iron_spikes",
				"group:flora"
			}
			self.replace_rate = 10
			self.replace_offset = -1
		end

		self.initial_hp = self.health
		-- used as reference when recovering health

		self.nametag = self.given_name .. "\n(" .. self.type .. ")"

		self.object:set_properties({
			type = self.type,
			name = self.given_name,
			nametag = self.nametag,
			heal_counter = 4.0,
			damage = self.damage,
			walk_chance = self.walk_chance,
			passive = self.passive,
			runaway = self.runaway,
			initial_hp = self.initial_hp,
			replace_what = self.replace_what,
			replace_offset = self.replace_offset,
			replace_rate = self.raplace_rate
		})
		return true
	end,

	-- Health recover
	do_custom = function(self, dtime)
		heal_over_time(self, dtime)

		if (self.type ~= "animal") then
			combat_tag(self)
			experience(self)
		end
	end,

	-- Bones' random spawner
	on_die = function(self, pos)
		local drop_bones = math.random(0, 9)

		if (drop_bones >= 5) then
			local pos = {x = pos.x, y = (pos.y -1), z = pos.z}
			local node_name = minetest.get_node(pos).name
			if (node_name == "air") then
				minetest.set_node(pos, {name="bones:bones"})
				minetest.check_single_for_falling(pos)
			end
		end
	end
})


--
-- Entity spawner
--

mobs:spawn({
	name = "mobs_humans:human",
	nodes = {"group:crumbly"},
	neighbors = {"air"},
	max_light = 15,
	min_light = 0,
	interval = 60,
	chance = 3500,
	active_object_count = 2,
	min_height = 1,
	max_height = 240,
	day_toggle = nil
})


--
-- Alias
--

mobs:alias_mob("mobs:human", "mobs_humans:human")


--
-- Minetest engine debug logging
--

if (minetest_log_level == nil) or (minetest_log_level == "action") or
	(minetest_log_level == "info") or (minetest_log_level == "verbose") then

	minetest.log("action", mod_load_message)
end
