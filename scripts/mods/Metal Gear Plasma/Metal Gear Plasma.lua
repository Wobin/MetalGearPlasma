--[[
Title: Metal Gear Plasma
Author: Wobin
Date: 28/06/2026
Repository: https://github.com/Wobin/MetalGearPlasma
Version: 3.0
]]--

local mod = get_mod("Metal Gear Plasma")
mod.version = "3.0"

local SimpleAudio
local Unit = rawget(_G, "Unit")

local ALERT_FILE = "Metal Gear Plasma/audio/alert.mp3"
local ALERT_VOLUME = 100
local ALERT_DECAY = 0.01
local ALERT_MIN_DISTANCE = 2
local ALERT_MAX_DISTANCE = 60
local WINDUP_DELAY = 1.3

local function is_unit_alive(unit)
    if not unit or type(unit) ~= "userdata" then return false end
    return Unit.alive(unit)
end

local function get_plasma_unit()
    if not debug.getinfo(8) then
        return nil
    end

    local v = 1
    while true do
        local name, value = debug.getlocal(8, v)
        if not name then
            return nil
        end
        if is_unit_alive(value) then
            return value
        end
        v = v + 1
    end
end

local function play_alert(cached_unit)
    if not SimpleAudio or not SimpleAudio.play_file then
        return
    end

    if is_unit_alive(cached_unit) then
        SimpleAudio.play_file(ALERT_FILE, {
            audio_type = "sfx",
            volume = ALERT_VOLUME,
        }, cached_unit, ALERT_DECAY, ALERT_MIN_DISTANCE, ALERT_MAX_DISTANCE)
    else
        SimpleAudio.play_file(ALERT_FILE, {
            audio_type = "sfx",
            volume = ALERT_VOLUME,
        })
    end
end

mod.on_all_mods_loaded = function()
    mod:info(mod.version)

    SimpleAudio = get_mod("SimpleAudio")
    if not SimpleAudio then
        mod:error("SimpleAudio is required.")
    end
end

local last_trigger = 0
local tc = Managers.time

mod:hook_safe(WwiseWorld, "trigger_resource_event", function(_, wwise_event_name, unit_or_position_or_id)
    if not wwise_event_name:match("play_minion_plasmapistol_charge") then return end

    local now = tc:time("main")
    if mod:get("reduce_noise") and (now - last_trigger) < 0.5 then
        return
    end
    last_trigger = now

    local cached_unit = get_plasma_unit()

    Promise.delay(WINDUP_DELAY):next(function()
        play_alert(cached_unit)
    end)

    if mod:get("play_sniper_flash") then
        Promise.delay(WINDUP_DELAY):next(function()
            Managers.ui:play_3d_sound("wwise/events/weapon/play_special_sniper_flash", unit_or_position_or_id)
        end)
    end
end)
