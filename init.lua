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

local mod_load_message = "[Mod] Mobs Humans [v0.1.1] loaded."

--
-- Chat messages
--

local MESSAGE_1 = "Saluton "
local MESSAGE_2 = ", mia nomo estas "


--
-- Function
--

local function random_damage()
    local damage = (math.random(1, 8) * mob_difficulty)
    return damage
end

local function random_armour()
    local armour = math.random(10, 100)
    return armour
end

local function random_string(length)

	local counter = 0
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

		counter = counter + 1

		local chosen_group = math.random(1, 5)

		if (exchanger == "vowel") then
			chosen_group = math.random(3, 5)

		elseif (exchanger == "semivowel") then
			chosen_group = 1

		elseif (exchanger == "simple consonant") then
			if (counter < length) then
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

			if (length ~= 2) then
				if (initial_letter == true) then
					initial_letter = false
					previous_letter = string.upper(semivowels[number])
					string = string .. previous_letter
				else
					previous_letter = semivowels[number]
					string = string .. previous_letter

				end

				exchanger = "semivowel"

			elseif (length == 2) then
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
    type = "npc",
    hp_min = 20,
    hp_max = 20,
    armor = 100,
    walk_velocity = 4,
    run_velocity = 4,
    walk_chance = 50,
    jump = false,
    view_range = 15,
    damage = 1,
    knock_back = false,
    lava_damage = 8,
    suffocation = true,
    floats = 1,
    reach = 4,
    attacks_monsters = true,
    group_attack = true,
    attack_type = "dogfight",
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

    on_spawn = function(self, pos)
        self.armor = random_armour()
        self.object:set_armor_groups({
            immortal = 1,
            fleshy = self.armor
        })
        self.damage = random_damage()
		self.object:set_properties({
			damage = self.damage
		})
		return true
    end,

	on_rightclick = function(self, clicker)
		if (self.health > 0) and (self.state ~= "attack")
		and (self.nametag == "") then
			self.nametag = random_string(math.random(2, 8))
			local player_name = clicker:get_player_name()

			local msg = MESSAGE_1 .. player_name .. MESSAGE_2
				.. self.nametag .. ".\n"
			minetest.chat_send_player(player_name, msg)

			self.object:set_properties({
                nametag = self.nametag
            })
		end
	end,
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
    chance = 75000,
    active_object_count = 1,
    min_height = 1,
    max_height = 240,
    day_toggle = true
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
