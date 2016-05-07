include                 = 0.14_monster_glyphs.txt

automagic_enable = true
automagic_slot = Q
tile_key_repeat_delay = 1200

bindkey = [;] CMD_AUTOFIGHT_NOMOVE 

flash_screen_message += distortion

explore_delay = 3
explore_greedy = true
explore_stop = shops,altars,portals,branches,runed_doors
explore_stop += greedy_pickup_smart,greedy_visited_item_stack
explore_wall_bias = 2
explore_auto_rest = true
rest_wait_both = true
rest_wait_percent = 95
runrest_ignore_monster ^= butterfly:1
runrest_ignore_monster ^= rat:2
auto_sacrifice = true

equip_unequip = true
easy_confirm = all
allow_self_target = prompt

show_more = false
messages_at_top = true
msg_max_height = 14
msg_min_height = 8

sort_menus = true : >identified, art, qty, basename, qualname, curse
default_show_all_skills = true
tile_menu_icons = false

fire_order  = launcher, return
fire_order += tomahawk / javelin / stone / rock / net

########################
### Autopick options ###
########################

## Add staves and rods; note you can't use += with this option.
autopickup = $?!+"/%|\

ae := autopickup_exceptions
## Don't ever need a second stave
ae += staff of .*
ae += useless_item, dangerous_item, evil_item

# Autopickup artefacts
ae += <artefact

# Armour/Weapon autopickup by rwbarton, enhanced by HDA with fixes from Bloaxor
{
add_autopickup_func(function(it, name)

  if name:find("curare") then return true end
  if name:find("dispersal") and (name:find("dart") or name:find("tomahawk")) then return true end
  if name:find("throwing net") then return true end
 
  local class = it.class(true)
  local armour_slots = {cloak="Cloak", helmet="Helmet", gloves="Gloves", boots="Boots", body="Armour", shield="Shield"}

  if (class == "armour") then
		if it.is_useless then return false end
		
    sub_type = it.subtype()
    equipped_item = items.equipped_at(armour_slots[sub_type])
 
    if (sub_type == "cloak") or (sub_type == "helmet") or (sub_type == "gloves") or (sub_type == "boots") then
      if not equipped_item then
        return true
      else
        return it.artefact or it.branded or it.ego
      end
    end
 
    if (sub_type == "body") then
      if equipped_item then
        local armourname = equipped_item.name()
        if equipped_item.artefact or equipped_item.branded or equipped_item.ego or (equipped_item.plus > 2) or armourname:find("dragon") or armourname:find("troll") then
          return it.artefact
        else
          return it.artefact or it.branded or it.ego
        end
      end
      return true
    end
 
    if (sub_type == "shield") then
      if equipped_item then
          return it.artefact or it.branded or it.ego
      end
    end
  end
 
  if (class == "weapon") then
		if it.is_useless then return false end
		
    if (you.xl() < 12) or (you.god():find("Nemelex")
                           or (you.god():find("Yred"))
                           or (you.god():find("Beogh"))) then
      if it.branded and not (it.name() == "club") then
        return false
      end
    end
    local weapon = items.equipped_at("Weapon")
    if weapon then
      if (weapon.branded or weapon.artefact) then return false
      else
        local weapon_name = weapon.name()
        local sb = you.skill("Short Blades")
        local lb = you.skill("Long Blades")
        local axe = you.skill("Axes")
        local mf = you.skill("Maces & Flails")
        local pole = you.skill("Polearms")
        local staff = you.skill("Staves")
        if sb > 6 then
          if name:find("quick blade") then return true end
        end
        if lb > 8 then
          if name:find("demon blade") then return true end
          if name:find("bastard sword") then return true end
          if name:find("double sword") then return true end
        end
        if lb > 14 then
          if name:find("claymore") then return true end
          if name:find("triple sword") then return true end
        end
        if axe > 8 and mf <= 8 then
          if name:find("battleaxe") then return true end
          if name:find("broad axe") then return true end
          if name:find("war axe") then return true end
          if name:find("executioner") then return true end
        end
        if axe > 18 then
          if name:find("executioner") then return true end
        end
        if mf > 8 and staff <= 8 and axe <= 8 then
          if name:find("eveningstar") then return true end
          if name:find("demon whip") then return true end
          if name:find("sacred scourge") then return true end
          if name:find("dire flail") then return true end
        end
        if mf > 14 and staff <= 14 and axe <= 14 then
          if name:find("great mace") then return true end
        end
        if pole > 8 and staff <= 8 then
          if name:find("trident") then return true end
          if name:find("demon trident") then return true end
          if name:find("trishula") then return true end
        end
        if pole > 14 and staff <= 14 then
          if name:find("glaive") then return true end
          if name:find("bardiche") then return true end
        end
        if staff > 8 then
          if name:find("lajatang") then return true end
        end
      end
    elseif (you.skill("Unarmed Combat") < 2) then
      return true
    end
  end
end)
}

####################
### Autoinscribe ###
####################

ai := autoinscribe

ai += (bad|dangerous)_item.*potion:!q
ai += (bad|dangerous)_item.*scroll:!r
ai += potion.*(berserk rage):!q
ai += potion.*(cure mutation):!q
ai += scroll.*blinking:!r
ai += scroll.*(magic mapping):!r
ai += scroll.*recharging:!r

ai += of faith:!P
ai += ( rod ):!a
ai += manual of:!d
ai += staff of (Wucad Mu|channeling|wizardry|conjuration|summoning):!a
ai += staff of air:rElec
ai += staff of cold:rC+
ai += staff of death:rN+
ai += staff of energy:+MP, hungerless spells, !a
ai += staff of fire:rF+
ai += staff of poison:rPois
ai += staff of power:MP+17, !a

## from simm's rc
ai += curing:@q1
ai += potions? of heal wounds:@q2
ai += wand of heal wounds:@v2
ai += potions? of haste:@q3
ai += wand of hasting:@v3
ai += scrolls? of teleportation:@r4
ai += wand of teleportation:@v4
ai += identify:@r1
ai += remove curse:@r2
ai += blowgun:@w1
ai += (curare|dispersal):!f

ai += throwing net:=f

ai += (meat|bread) ration:@e1
ai += (beef jerk|pizza):@e2
ai += royal jell:@e3
ai += fruit:@e4

# Save fruit for abilities under Fedhas
: if you.god() == "Fedhas" then
	ai += fruit:!e
: end

# Inscribe potions of blood if you are a vampire
: if you.race() == "Vampire" then
        ai += potion.*blood:@q4
: end 

# Inscribe distortion weapons if you are not worshipping Lugonu
: if you.god() ~= "Lugonu" then
	ai += distortion:!w
  ai += (Sonja|Psyche):!w
: end

# Body Armour
ai += fire dragon (armour|hide):rF++, rC-
ai += gold dragon (armour|hide):rC+, rF+, rPois
ai += ice dragon (armour|hide):rC++, rF-
ai += mottled dragon (armour|hide):rSticky
ai += pearl dragon (armour|hide):rN+
ai += quicksilver dragon armour:MR+
ai += shadow dragon (armour|hide):Stlth++++
ai += steam dragon (armour|hide):rSteam
ai += storm dragon (armour|hide):rElec
ai += swamp dragon (armour|hide):rPois
ai += troll (hide|leather armour):regen

show_god_gift = unident

#########
# Notes #
#########

note_items    += acquirement, of Zot
note_messages += You pass through the gate
note_messages += cast .* Abyss
note_messages += Your scales start
note_messages += protects you from harm
note_messages += You fall through a shaft
## Nasty undead from Vaults and Tomb
note_monster  += lich,ancient lich,curse skull,greater mummy
## Some enemies it's good to note for Vaults:5
note_monsters += tengu reaver,storm dragon,titan
## Depths
note_monsters += octopode crusher,juggernaut,caustic shrike
## Zot
note_monsters += killer klown,electric golem,death cob,curse toe,orb of fire

#####################
### More messages ###
#####################

more := force_more_message

# Important features
: if you.god() == "Ashenzari" then
more += You have a vision of.*gates?
: else
more += interdimensional caravan
more += distant snort
more += Found a gateway leading out of the Abyss
: end
more += Found .* abyssal rune of Zot
more += You feel a terrible weight on your shoulders

# Interrupts
more += You don't.* that spell
more += You fail to use your ability
more += You miscast
more += You can't (read|drink|do) that
more += That item cannot be evoked
more += This wand has no charges
more += You are held in a net
more += You don't have any such object
more += do not work when you're silenced
more += You can't unwield
more += enough magic points
more += You feel your control is inadequate

# Bad things
more += Your surroundings flicker
more += sense of stasis
more += You cannot teleport right now
more += The writing blurs in front of your eyes
more += You fall through a shaft
more += (blundered into a|invokes the power of) Zot
more += Ouch! That really hurt!
more += dispelling energy hits you
more += You convulse
more += You are (blasted|electrocuted)!
more += You are (more )?confused
more += You are (more |lethally )?poisoned
more += wrath finds you
more += lose consciousness
more += Space warps horribly around you
more += hits you.*distortion
more += Space bends around you\.
more += watched by something
more += The dungeon rumbles around
more += The air twists around and violently strikes you in flight

# Expiring effects
more += You feel yourself slow down
more += You are starting to lose your buoyancy
more += Your hearing returns
more -= Your transformation is almost over
more += You feel yourself come back to life
more += uncertain

# Others
more += You have reached level
more += You have finished your manual of
more += Deactivating autopickup

## Problematic monsters
more += (giant eyeball|shining eye|cacodemon|neqoxec|guardian serpent|flayed ghost|greater mummy|mummy priest|hell sentinel|fiend|tormentor|hellion|lich|executioner|orb of fire|death cob|juggernaut|moth of wrath|ghost moth|curse toe|curse skull|draconian shifter).*into view

## Uniques
more += (Agnes|Aizul|Antaeus|Asmodeus|Asterion|Azrael|Blork the orc|Boris|Cerebov|Crazy Yiuf|Dispater|Dissolution|Donald|Dowan|Duvessa|Edmund|the Enchantress|Ereshkigal|Erica|Erolcha|Eustachio|Fannar|Frances|Frederick|Gastronok|Geryon|Gloorx Vloq|Grinder|Grum|Harold|Ignacio|Ijyb|Ilsuiw|Jessica|Jorgrun|Jory|Joseph|Josephine|Khufu|Kirke|Lamia|the Lernaean hydra|Lom Lobon|Louise|Mara|Margery|Maud|Maurice|Menkaure|Mennas|Mnoleg|Murray|Natasha|Nergalle|Nessos|Nikola|Norris|Pikel|Plog|Polyphemus|Prince Ribbit|Psyche|Purgy|Robin|Roxanne|the royal jelly|Rupert|Saint Roka|the Serpent of Hell|Sigmund|Snorg|Sonja|Terence|Tiamat|Urug|Vashnia|Wiglaf|Xtahua).*into view

##### Fake Language ########################################################

: if (you.god() == "Trog") then
: if (you.race() == "Troll" or you.race() == "Ogre") then
fake_lang = wide,grunt
: elseif (you.race() == "Deep Dwarf") then
fake_lang = dwarven,grunt
: else
fake_lang = grunt
: end
#: elseif (you.race() == "Mummy") then
#fake_lang = runes
#: elseif (you.race() == "Vampire") then
#fake_lang = jagerkin,kraut
: else
fake_lang = 
: end


#fake_lang = kraut,jagerkin
#fake_lang = jagerkin,kraut

#fake_lang = kraut,dwarven,jagerkin
#fake_lang = dwarven,kraut,jagerkin
#fake_lang = dwarven,jagerkin,kraut
#fake_lang = jagerkin,kraut,dwarven
#fake_lang = kraut,jagerkin,dwarven
#fake_lang = jagerkin,dwarven,kraut

##############################
## Lua and ready() function ##
##############################
{

-- Spellcasting spam reduction by monqy
local function generic_cast_spell(cmd)
  crawl.mpr('<cyan>Cast which spell?</cyan>')
  crawl.flush_prev_message()
  crawl.process_keys(cmd)
end

function cast_spell()
  generic_cast_spell('z')
end

function force_cast_spell()
  generic_cast_spell('Z')
end

-- Note: My final rc file has the lua files from
-- https://github.com/gammafunk/dcss-rc included on the line below.
-----------------------------
---- Begin target_skill ----
-----------------------------

-- Opens the skill screen automaticaly when a skill reaches a target level set
-- by the player. To enable in your rc, add a lua code block with the contents
-- of *target_skill.lua* and a call to `target_skill()` in your `ready()`
-- function. Additionally you'll wand to assign a key to a macro with a target
-- of `===set_target_skill` so can change the skill target on the fly. Original
-- code by elliptic with some reorganization.

skill_list = {"Fighting","Short Blades","Long Blades","Axes","Maces & Flails",
              "Polearms","Staves","Unarmed Combat","Bows","Crossbows",
              "Throwing","Slings","Armour","Dodging","Shields","Spellcasting",
              "Conjurations","Hexes","Charms","Summonings","Necromancy",
              "Translocations","Transmutations","Fire Magic","Ice Magic",
              "Air Magic","Earth Magic","Poison Magic","Invocations",
              "Evocations","Stealth"}
need_target_skill = nil

function record_current_skills(maxlev)
  c_persist.current_skills = { }
  for _,sk in ipairs(skill_list) do
    if you.train_skill(sk) > 0 and you.base_skill(sk) < (maxlev or 27) then
      table.insert(c_persist.current_skills, sk)
    end
  end
end

function check_skills()
  if not c_persist.current_skills or not c_persist.target_skill then
    return
  end
  for _,sk in ipairs(c_persist.current_skills) do
    if you.base_skill(sk) >= c_persist.target_skill then
      crawl.formatted_mpr(sk .. " reached " .. c_persist.target_skill
                          .. ".", "prompt")
      crawl.more()
      set_new_skill_training()
      break
    end
  end
end

function init_target_skill()
  c_persist.target_skill = nil
  c_persist.current_skills = { }
  need_target_skill = true
end

function set_new_skill_training()
  init_target_skill()
  c_persist.target_skill = 0
  crawl.sendkeys("m")
end

function set_target_skill()
  record_current_skills()
  local str = "Currently training: "
  local first_skill = true
  for _,sk in ipairs(c_persist.current_skills) do
    val = you.base_skill(sk)
    if first_skill then
      str = str .. sk .. "(" .. val .. ")"
    else
      str = str .. ", " .. sk .. "(" .. val .. ")"
    end
    first_skill = false
  end
  str = str .. "."
  crawl.formatted_mpr(str, "prompt")
  crawl.formatted_mpr("Choose a target skill level: ", "prompt")
  c_persist.target_skill = tonumber(crawl.c_input_line())
  record_current_skills(c_persist.target_skill)
  -- Update the target skill for char_defaults if necessary.
  if save_default_target_skill and you.turns() == 0 then
      save_default_target_skill()
  end
end

function control(c)
  return string.char(string.byte(c) - string.byte('a') + 1)
end

-- Moved this to its own function to clean up ready() -gammafunk
function target_skill()
  prev_need_target = need_target_skill

  -- Need to look at skills and then set a target skill if our
  -- need_target_skill variable is uninitialized and we're either at turn 0 or
  -- c_persist.target_skill also uninitialized.
  if prev_need_target == nil
  and (you.turns() == 0 or c_persist.target_skill == nil) then
    set_new_skill_training()
  end
  if prev_need_target then
    set_target_skill()
    need_target_skill = false
  elseif not need_target_skill then
    check_skills()
  end
end

--------------------------
---- End target_skill ----
--------------------------

##### Crawl Init file ###############################################
# For descriptions of all options, as well as some more in-depth information
# on setting them, consult the file
#    options_guide.txt
# in your /docs directory. If you can't find it, the file is also available
# online at:
# https://github.com/crawl/crawl/blob/master/crawl-ref/docs/options_guide.txt
#
# Crawl uses the first file of the following list as its option file:
#  * init.txt in the -rcdir directory (if specified)
#  * .crawlrc in the -rcdir directory (if specified)
#  * init.txt (in the Crawl directory)
#  * ~/.crawl/init.txt (Unix only)
#  * ~/.crawlrc (Unix only)
#  * ~/init.txt (Unix only)
#  * settings/init.txt (in the Crawl directory)

##### Some basic explanation of option syntax #######################
# Lines beginning with '#' are comments. The basic syntax is:
#
# field = value         or      field.subfield = value
#
# Only one specification is allowed per line.
#
# The terms are typically case-insensitive except in the fairly obvious
# cases (the character's name and specifying files or directories when
# on a system that has case-sensitive filenames).
#
# White space is stripped from the beginning and end of the line, as
# well as immediately before and after the '='. If the option allows
# multiple comma/semicolon-separated terms (such as
# autopickup_exceptions), all whitespace around the separator is also
# trimmed. All other whitespace is left intact.
#
# There are three broad types of Crawl options: true/false values (booleans),
# arbitrary values, and lists of values. The first two types use only the
# simple =, with later options - which includes your options that are different
# from the defaults - overriding earlier ones. List options allow using +=, ^=,
# -=, and = to append, prepend, remove, and reset, respectively. Usually you will
# want to use += to add to a list option. Lastly, there is := which you can use
# to create an alias, like so:
#   ae := autopickup_exceptions
# From there on, 'ae' will be treated as if it you typed autopickup_exceptions,
# so you can save time typing it.
#

##### Other files ###################################################
# You can include other files from your options file using the 'include'
# option. Crawl will treat it as if you copied the whole text of that file
# into your options file in that spot. You can uncomment some of the following
# lines by removing the beginning '#' to include some of the other files in
# this folder.

# Some useful, more advanced options, implemented in LUA.
# include = advanced_optioneering.txt

# Alternative vi bindings for Dvorak users.
# include = dvorak_command_keys.txt

# Alternative vi bindings for Colemak users.
# include = colemak_command_keys.txt

# Override the vi movement keys with a non-command.
# include = no_vi_command_keys.txt

# Turn the shift-vi keys into safe move, instead of run.
# include = safe_move_shift.txt

##### Ancient versions ##############################################
# If you're used to the interface of ancient versions of Crawl, you may
# get back parts of it by uncommenting the following options:

# include                 = 034_command_keys.txt

# And to revert monster glyph and colouring changes:

# include                 = 034_monster_glyphs.txt
# include                 = 052_monster_glyphs.txt
# include                 = 060_monster_glyphs.txt
# include                 = 071_monster_glyphs.txt
# include                 = 080_monster_glyphs.txt
# include                 = 0.9_monster_glyphs.txt
# include                 = 0.12_monster_glyphs.txt
# include                 = 0.13_monster_glyphs.txt
