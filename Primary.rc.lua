# lines that begin with # are comments. if that comment contains code, deleting the #
# will make the code take effect. All settings can be tweaked, but be careful with LUA

# This is a fairly-comprehensive Circus Animals rc file.
# Decided to roll my own because the HDA files, while awesome, have a bunch of
# food-related functions that behave strangely in our fork. Suggestions welcome!
# Some parts of this were copied from gammafunk and zxc. Thanks, you two!

# if playing on CPO, remove these two includes, and un-comment the other two includes
  include += RumpyForceMore.rc
  include += RumpyColors.rc
# include += zxcForceMores.rc
# include += HDAColors.rc

  automagic_enable	= true
  automagic_stop 	= 20
  mp_warning 		= 15
  automagic_slot 	= Q
  autofight_throw	= true
# the ingenious plan: instead of setting autofight_stop to a high value, lets have
# a "warning" at 60 and then you can keep tabbing to death, or at least to 40% hp
  hp_warning 		= 60
  autofight_stop 	= 40
  danger_mode_threshold	= 40

tile_key_repeat_delay = 1500

bindkey = [;] CMD_AUTOFIGHT_NOMOVE 
# the following bindkeys help with turncount, by attempting to breadswing instead of resting
# comment them out or delete them if you dont want that behaviour
bindkey = [.] ===one_turn_rest
bindkey = [5] ===start_resting

flash_screen_message += distortion
: if you.race() == "Formicid" then
	flash_screen_message += poison
: end

explore_delay 		= 1
explore_greedy 		= true
explore_stop 		= shops,altars,portals,branches,runed_doors
explore_stop 	       += greedy_pickup_smart,greedy_visited_item_stack
explore_wall_bias 	= 2
explore_auto_rest 	= true
rest_wait_both 		= true
rest_wait_percent 	= 96
runrest_ignore_poison 	= 2:10
runrest_ignore_monster ^= butterfly:1
runrest_ignore_monster ^= rat:3
auto_sacrifice 		= true
show_travel_trail	= true
message_colour         += mute:you're not good enough to have a special ability
message_colour 	       += mute:@corpse

equip_unequip 		= true
easy_confirm 		= all
allow_self_target 	= prompt

show_more 		= false
show_gold_turn		= true
show_game_turns 	= true
default_manual_training = true
view_delay 		= 600

sort_menus 		= true : charged, >identified, >equipped, art, qty, basename, qualname, curse
drop_filter  	       ^= useless, forbidden, dangerous
default_show_all_skills = true
tile_menu_icons 	= false
ability_menu 		= true
default_manual_training = true

hp_colour       = 100:green, 75:yellow, 50:red, 25:lightred
mp_colour       = 100:green, 75:yellow, 50:red, 25:lightred
: if you.race() == "Lava Orc" then
temp_colour	= 100:red, 94:lightred, 86:yellow, 59:brown, 32:darkgrey
: end

fire_order  = launcher, return
fire_order += tomahawk / javelin / stone / rock / net

########################
### Autopick options ###
########################

## Add staves and rods; note you can't use += with this option.
autopickup = $?!+"/%|\}(

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
  if name:find("dispersal") then return true end
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
# Autoinscriptions #
####################

ai := autoinscribe

ai += (vampiric):!w
ai += (bad|dangerous)_item.*potion:!q
ai += (bad|dangerous)_item.*scroll:!r
ai += of faith:!P
ai += rod of:!a
ai += lightning rod:!a
ai += [^r]staff of (conj|energy|power|wizardry|Wucad Mu):!a
ai += dispersal:!f
ai += throwing net:!f

: if you.god() ~= "Lugonu" then
ai += (distortion):!w
:end

ai += of identify:@r1
ai += remove curse:@r2
ai += curing:@q1
ai += potions? of heal wounds:@q2
ai += wand of heal wounds:@v2
ai += wand of hasting:@v3
ai += potions? of haste:@q3
ai += scrolls? of teleportation:@r4
ai += wand of teleportation:@v4
ai += potions? of blood:@q0

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

show_god_gift = unident

#########
# Notes #
#########

dump_item_origins = all
dump_message_count = 50
dump_book_spells = false
dump_order =
dump_order += header,hiscore,stats,misc,mutations,skills,spells,overview
dump_order += inventory,screenshot,monlist,messages
dump_order += vaults,kills,turns_by_place,kills_by_place,notes,action_counts
ood_interesting = 6
note_hp_percent = 25
note_all_skill_levels = true
note_items    += acquirement, of Zot
note_messages += You pass through the gate
note_messages += cast .* Abyss
note_messages += Your scales start
note_monsters += lich,ancient lich,curse skull,greater mummy
note_monsters += tengu reaver,storm dragon,titan
note_monsters += octopode crusher,juggernaut,caustic shrike
note_monsters += killer klown,electric golem,death cob,curse toe,orb of fire

##### Fake Language ########################################################

: if (you.god() == "Trog") then
: if (you.race() == "Cave Troll" or you.race() == "Orc" or you.race() == "Ogre") then
fake_lang = wide,grunt
: elseif (you.race() == "Deep Dwarf") then
fake_lang = dwarven,grunt
: else
fake_lang = grunt
: end
: elseif (you.race() == "Mummy" or you.race() == "Moon Troll") then
fake_lang = runes
: elseif (you.race() == "Vampire" or you.race() == "Demonspawn") then
fake_lang = jagerkin,kraut
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

## LUA be careful LUA #
##https://github.com/gammafunk/dcss-rc/blob/master/README.md###
## LUA and ready() function ##
##https://github.com/gammafunk/dcss-rc/blob/master/README.md## 
{
  function ready()
    target_skill()
    load_message()
    speedrun_rest()
    char_dump()
    
  end
}
{
-----------------------------
---- Begin target_skill ----
-----------------------------

-- See https://github.com/gammafunk/dcss-rc/blob/master/README.md for documentation.

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
}
{
----------------------------
---- Begin load_message ----
----------------------------

-- See README.md for documentation.

message_color = "white"

-- Wrapper of crawl.mpr() that prints text in white by default.
if not mpr then
    mpr = function (msg, color)
        if not color then
            color = "white"
        end
        crawl.mpr("<" .. color .. ">" .. msg .. "</" .. color .. ">")
    end
end

function save_with_message()
    if you.turns() == 0 then
        crawl.sendkeys("S")
        return
    end
    crawl.formatted_mpr("Save game and exit?", "prompt")
    local res = crawl.getch()
    if not (string.char(res) == "y" or string.char(res) == "Y") then
        crawl.formatted_mpr("Okay, then.", "prompt")
        return
    end
    crawl.formatted_mpr("Leave a message: ", "prompt")
    local res = crawl.c_input_line()
    c_persist.message = res
    crawl.sendkeys(control("s"))
end

function load_message()
    if c_persist.message and c_persist.message ~= "nil"
    and c_persist.message ~= "" then
        mpr("MESSAGE: " .. c_persist.message, message_color)
        c_persist.message = nil
    end
end

-----------------------------------
---- End leave message on save ----
-----------------------------------
}
{
-----------------------------
---- Begin speedrun_rest ----
-----------------------------

-- See README.md for documentation.

-- How many turns to rest at max.
num_rest_turns = 20

-- If true, look for a foot item inventory slot and use fallback_slot if we
-- can't find a ration. If false, always use fallback_slot.
automatic_slot = true

-- Slot where you keep your slow swing item.
fallback_slot = "c"

-- Set to true to have Na characters always walk instead of item swing if
-- they're able to walk slowly. This is not as turncount efficient for non-Chei
-- worshipers, but some Na players may prefer it over having to change the
-- wielded weapon.
naga_always_walk = false

-- Delay in milliseconds before sending the next walk command. Makes the
-- visuals a bit less jarring when using walk resting. Set to 0 to disable.
walk_delay = 50

-- To have the multi-turn rest ignore status change messages, add an entry here
-- giving the pattern of the message you'd like to ignore. The entries below
-- cover the transition messages from the regen spell, Trog's hand, and poison
-- status. The key should be the status that's seen in the output of
-- `you.status()` when the status is active, and the value should be a single
-- pattern string or an array of pattern strings matching the message you'd
-- like to ignore. See the lua string library manual for details on making
-- patterns.
status_messages = {
    ["poisoned"] = {"You feel[^%.]+sick%.",
                    "You are no longer poisoned%."},
    ["regenerating"] = {"You feel the effects of Trog's Hand fading%.",
                        "Your skin is crawling a little less now%."}
} --end status_messages

-- Like status_messages above, but for arbitrary messages. Any message matching
-- one of these patterns is ignored.
ignore_messages = {
    --RandomTiles messages
    "Trog roars: Now[^!]+!+",
    "Sif Muna whispers: Become[^!]+!+",
    "[^:]+ says: Become[^!]+!+",
    --Debug messages
    "Dbg:.*",
} -- end ignore_messages

-- NOTE: No configuration past this point.

ATT_NEUTRAL = 1

version = 0.15
if crawl.version then
    version = tonumber(crawl.version("major"))
end
los_range = version >= 0.17 and 7 or 8

-- Wrapper of crawl.mpr() that prints text in white by default.
if not mpr then
    mpr = function (msg, color)
        if not color then
            color = "white"
        end
        crawl.mpr("<" .. color .. ">" .. msg .. "</" .. color .. ">")
    end
end

function control(c)
    return string.char(string.byte(c) - string.byte('a') + 1)
end

function delta_to_vi(dx, dy)
    local d2v = {
        [-1] = { [-1] = 'y', [0] = 'h', [1] = 'b'},
        [0]  = { [-1] = 'k',            [1] = 'j'},
        [1]  = { [-1] = 'u', [0] = 'l', [1] = 'n'},
    } -- hack
    return d2v[dx][dy]
end

function reset_rest()
    -- Clear out the now-unused persistant table in old versions
    if c_persist.bread then
        c_persist.bread = nil
    end
    if not rstate then
        rstate = { }
        rstate.set_slot = false
        rstate.dir_x = nil
        rstate.dir_y = nil
    end
    rstate.last_acted = nil
    rstate.wielding = false
    rstate.resting = false
    rstate.num_turns = nil
    rstate.rest_start = nil
    rstate.start_hp = nil
    rstate.start_status = { }
    rstate.start_message = nil
end

function abort_rest(msg)
    if msg then
        mpr(msg, "lightred")
    end
    reset_rest()
end

function crawl_message(i)
    local msg = crawl.messages(i):gsub("\n", "")
    msg = msg:gsub("^%c* *", "")
    msg = msg:gsub(" *%c*?$", "")
    return msg
end

function record_status()
    -- Record starting status to track any status changes.
    rstate.start_status = { }
    local status = you.status()
    for s,_ in pairs(status_messages) do
        if status:find(s) then
            rstate.start_status[s] = true
        end
    end
    rstate.start_message = get_last_message()
end

function in_water()
    return view.feature_at(0, 0):find("water") and not you.status("flying")
end

function get_last_message()
    local rest_type = get_rest_type()
    local in_water = in_water()
    -- Ignore these movement messages when walking.
    local move_patterns = {"There is a[^%.]+here.",
                           "Things that are here:.*",
                           "Items here:.*"}
    for i = 1,200 do
        local msg = crawl_message(i)
        for s,_ in pairs(rstate.start_status) do
            if type(status_messages[s]) == "table" then
                for _,p in ipairs(status_messages[s]) do
                    msg = msg:gsub(p, "")
                end
            else
                msg = msg:gsub(status_messages[s], "")
            end
        end
        if rest_type == "walk" then
            for _,p in ipairs(move_patterns) do
                -- Also remove any whitespace.
                msg = msg:gsub(" *" .. p .. " *", "")
            end
        end
        msg = msg:gsub(" *Beep! [^%.]+%. *", "")
        for _,p in ipairs(ignore_messages) do
            msg = msg:gsub(p, "")
        end
        if msg ~= "" then
            return msg
        end
    end
    return nil
end

function wield_swing_item()
    rstate.wielding = true
    rstate.last_acted = you.turns()
    record_status()
    crawl.sendkeys("w" .. c_persist.swing_slot)
end

function find_swing_slot()
    rstate.set_slot = true
    if not automatic_slot then
        c_persist.swing_slot = fallback_slot
        return
    end
    c_persist.swing_slot = nil
    for _,item in ipairs(items.inventory()) do
        if item.class() == "Comestibles" then
            c_persist.swing_slot = items.index_to_letter(item.slot)
            break
        end
    end
    if not c_persist.swing_slot then
        c_persist.swing_slot = fallback_slot
    end
end

function swing_item_wielded()
    local weapon = items.equipped_at("Weapon")
    return weapon and weapon.slot == items.letter_to_index(c_persist.swing_slot)
end

function hostile_in_los()
    local have_t1 = false
    for x = -los_range,los_range do
        for y = -los_range,los_range do
            m = monster.get_monster_at(x, y)
            if m and not m:is_safe() then
                return true
            end
        end
    end
    return false
end

function ponderous_level()
    local level = 0
    for _,item in ipairs(items.inventory()) do
        local ego = item.ego()
        if item.equipped and ego == "ponderousness" then
            level = level + 1
        end
    end
    return level
end

-- XXX See if we can move at least some of this into clua, since it's
-- recreating play_movement_speed() and player_speed(). The aim is to determine
-- if slow move is more regen-efficient and that the saving is worth the
-- hassle, this calculates the minimum move speed, which can normally vary at
-- random from randomized delay (e.g. water) and the many uses of
-- div_rand_round().
function player_move_speed()
    if you.transform() == "tree" then
        return 0
    end

    local in_water = in_water()
    local walk_water = you.race() == "Merfolk"
        or you.race() == "Octopode"
        or you.god() == "Beogh" and you.piety_rank() == 5
        or you.transform == "ice"

    -- This is player action speed, based on things that affect all actions.
    local player_speed = 10
    if you.status("slowed") then
        player_speed = math.floor(player_speed * 3 / 2)
    end
    if you.status("berserking") and you.god() ~= "Cheibriados"
    or  you.status("hasted") then
        player_speed = math.floor(player_speed * 2 / 3)
    end
    if you.transform() == "statue" or you.status("petrifying") then
        player_speed = math.floor(player_speed * 3 / 2)
    end
    if in_water and not walk_water then
        player_speed = math.floor(player_speed * 13 / 10)
    end

    -- This is the base player movement speed given all things that affect only
    -- movement.
    local move_speed = 10
    if you.transform() == "bat" then
        move_speed = 5
    elseif you.transform() == "pig" then
        move_speed = 7
    elseif you.transform() == "porcupine" or you.transform == "wisp" then
        move_speed = 8
    elseif in_water and (you.transform() == "hydra"
                         or you.race() == "Merfolk") then
        move_speed = 6
    elseif you.race() == "Tengu" and you.status("flying") then
        move_speed = 9
    end

    local boots = items.equipped_at("Boots")
    local running_level = 0
    if boots
        and not boots.is_melded
        and boots.ego()
    and boots.ego() == "running" then
        running_level = 1
    end
    move_speed = move_speed - running_level
    move_speed = move_speed + ponderous_level()

    if you.god() == "Cheibriados" then
        -- Calculate this based on the minimum piety at the observed rank,
        -- since we can't know the true piety level.
        local piety_breaks = { 1, 30, 50, 75, 100, 120, 160 }
        move_speed = move_speed + 2 +
            math.floor(math.min(piety_breaks[you.piety_rank() + 1] / 20, 8))
    end

    if you.status("frozen") then
        move_speed = move_speed + 4
    end
    if you.status("grasped by roots") then
        move_speed = move_speed + 3
    end

    local speed_mut = you.mutation("speed")
    local slow_mut = you.mutation("slowness")
    if speed_mut > 0 then
        move_speed = move_speed - speed_mut - 1
    elseif slow_mut > 0 then
        move_speed = math.floor(move_speed * (10 +  slow_mut * 2) / 10)
    end

    if not in_water and you.status("sluggish") then
        if move_speed >= 8 then
            move_speed = math.floor(move_speed * 3 / 2)
        elseif move_speed == 7 then
            move_speed = math.floor(7 * 6 / 5)
        end
    elseif not in_water and you.status("swift") then
        move_speed = math.floor(move_speed * 3 / 4)
    end
    if move_speed < 6 then
        move_speed = 6
    end
    return math.floor(player_speed * move_speed / 10)
end

function get_rest_type()
    if you.race() == "Naga" and naga_always_walk
        or you.god() == "Cheibriados"
    or not weapon_can_swap() then
        return "walk"
    else
        return "item"
    end
end

function bad_to_act()
    local hp, mhp = you.hp()
    local rest_type = get_rest_type()
    -- Stop multiple turn action when our hp recovers.
    if rstate.rest_start and rstate.start_hp < mhp and hp == mhp then
        mpr("HP restored.")
        reset_rest()
        return true
    end
    if you.status("manticore barbs") then
        abort_rest("You must remove the manticore barbs first.")
        return true
    end
    if you.hunger_name() == "fainting" or you.hunger_name() == "starving" then
        abort_rest("You need to eat!")
        return true
    end
    if hostile_in_los() then
        if not rstate.rest_start then
            abort_rest("You can't rest with a hostile monster in view!")
        else
            abort_rest()
        end
        return true
    end

    -- If any unrecognized message occurs, assume we need to stop resting.
    if rstate.last_acted then
        local msg = get_last_message()
        if not msg then
            abort_rest("Unable to find a previous message!")
            return true
        end
        local wield_pt = "^ *" .. c_persist.swing_slot .. " - .+[%)}] *$"
        local swing_pt = "^ *You swing at nothing%. *$"
        local pattern = rstate.wielding and wield_pt or swing_pt
        if (rest_type == "item" and not msg:find(pattern))
        or rest_type == "walk" and msg ~= rstate.start_message then
            abort_rest()
            return true
        end
    end

    if rest_type == "walk" and player_move_speed() <= 10 then
        abort_rest("You cannot walk slowly right now!")
        return true
    end
    return false
end

function feat_is_open(feat)
    local fname = feat:lower()
    -- Unique substrings that identify solid features.
    local solid_features = {"wall", "grate", "tree", "mangrove",
                            "endless_lava", "open_sea", "statue", "idol",
                            "malign_gateway", "sealed_door", "closed_door",
                            "runed_door", "explore_horizon"}

    for i,p in ipairs(solid_features) do
        if fname:find(p) then
            return false
        end
    end
    return true
end

function safe_walk_pos(x, y)
    local in_water = in_water()
    local pos_is_water = view.feature_at(x, y):find("water")
    -- Don't allow walking out of water if we're in water
    return (in_water and pos_is_water
            -- Don't allow walking into water if we're not in it
                or not in_water and not pos_is_water)
    -- Require the destination to be safe.
        and view.is_safe_square(x, y)
end

function safe_swing_pos(x, y)
    return not monster.get_monster_at(x, y)
        and feat_is_open(view.feature_at(x,y))
end

function safe_direction(x, y)
    if get_rest_type() == "walk" then
        return safe_walk_pos(x, y)
    else
        return safe_swing_pos(x, y)
    end
end

function weapon_can_swap()
    local weapon = items.equipped_at("Weapon")
    if not weapon then
        return true
    end
    if weapon.cursed then
        return false
    end

    local ego = weapon.ego()
    -- Some unrands like Plut. sword have no ego.
    if ego
        and (ego == "vampirism"
             or ego == "distortion" and you.god() ~= "Lugonu") then
        return false
    end

    if weapon.artefact then
        local artp = weapon.artprops
        return not (artp["*Contam"] or artp["*Curse"] or artp["*Drain"])
    end
    return true
end

function get_safe_direction()
    local have_t1 = false
    for x = -1,1 do
        for y = -1,1 do
            if (x ~= 0 or y ~= 0) and safe_direction(x, y) then
                return x, y
            end
        end
    end
    return nil
end

function do_resting()
    -- Our first turn of resting.
    if not rstate.rest_start then
        record_status()
        rstate.rest_start = you.turns()
        rstate.start_hp = you.hp()
    end
    rstate.last_acted = you.turns()
    local rest_type = get_rest_type()
    if rest_type == "item" then
        crawl.sendkeys(control(delta_to_vi(rstate.dir_x, rstate.dir_y)))
    else
        local cur_x = rstate.dir_x
        local cur_y = rstate.dir_y
        -- Save the return direction as our next direction.
        rstate.dir_x = -rstate.dir_x
        rstate.dir_y = -rstate.dir_y
        crawl.sendkeys(delta_to_vi(cur_x, cur_y))
        crawl.delay(walk_delay)
    end
end

function one_turn_rest()
    rstate.resting = true
    rstate.num_turns = 1
end

function start_resting()
    rstate.resting = true
    rstate.num_turns = num_rest_turns
end

function set_swing_slot()
    crawl.formatted_mpr("Enter an slot letter for the swing item: ", "prompt")
    local letter = crawl.c_input_line()
    local index = items.letter_to_index(letter)
    if not index or index < 0 then
        mpr("Must be a letter (a-z or A-Z)!", "lightred")
        return
    end
    c_persist.swing_slot = letter
    rstate.set_slot = true
    mpr("Set swing slot to " .. letter .. ".")
end

function speedrun_rest()
    local rest_type = get_rest_type()
    if rest_type == "item"
        and (not c_persist.swing_slot
             or you.turns() == 0 and not rstate.set_slot) then
        find_swing_slot()
    end

    if not rstate.resting then
        return
    end

    -- Only act once per turn.
    if rstate.last_acted == you.turns() then
        -- An error happened with the 'w' command
        if rstate.wielding and not swing_item_wielded() then
            abort_rest("Unable to wield swing item on slot " ..
                           c_persist.swing_slot .. "!")
        end
        return
    end

    if rstate.last_acted and rstate.rest_start
    and rstate.last_acted + 1 >= rstate.rest_start + rstate.num_turns then
        reset_rest()
        return
    end

    if bad_to_act() then
        return
    end

    if rest_type == "item" and not swing_item_wielded() then
        wield_swing_item()
        return
    end

    rstate.wielding = false
    if not rstate.dir_x
    -- Don't try to reuse our position if we were walk resting and did
    -- something inbetween our last rest.
        or swing_type == "walk" and rstat.last_acted ~= you.turns() - 1
    or not safe_direction(rstate.dir_x, rstate.dir_y) then
        rstate.dir_x, rstate.dir_y = get_safe_direction()
        if not rstate.dir_x then
            abort_rest("No safe direction found!")
            return
        end
    end
    do_resting()
end

reset_rest()

---------------------------
---- End speedrun_rest ----
---------------------------
}
{
-------------------------
---- Begin char_dump ----
-------------------------

-- See README.md for documentation.

local dump_count = you.turns()
local dump_period = 1000

function char_dump()
    if you.turns() >= dump_count then
        dump_count = dump_count + dump_period
        crawl.dump_char()
    end
end

-----------------------
---- End char_dump ----
-----------------------
}
##### Crawl Init file ###############################################
# For descriptions of all options, as well as some more in-depth information
# on setting them, consult the file
# https://github.com/crawl/crawl/blob/master/crawl-ref/docs/options_guide.txt

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
