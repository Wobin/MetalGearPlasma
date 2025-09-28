local mod = get_mod("Metal Gear Plasma")
mod.version = "2.1.0"

local Audio

mod.on_all_mods_loaded = function()
    mod:info(mod.version)    
    Audio = get_mod("Audio")
    if Audio then 
        Audio.hook_sound("wwise/events/weapon/play_minion_plasmapistol_charge", function(_, _, delta) 
            if (mod:get("reduce_noise") and (delta == nil or delta > 0.5)) or not mod:get("reduce_noise") then                        
               Audio.play_file("alert.mp3", { audio_type = "sfx", adelay="500:all=1" })
            end
        end)        
    end
end

local throttle = {}
local tc = Managers.time

  mod:hook_safe(WwiseWorld, "trigger_resource_event", function(_, wwise_event_name, unit_or_position_or_id)        
    if not mod:get("play_sniper_flash") then return end    
    if not wwise_event_name:match("play_minion_plasmapistol_charge") then return end
    -- throttle half a second on each type
	local lastCall = throttle[wwise_event_name] or 0
	local delta = tc:time("main") - lastCall
	if mod:get("reduce_noise") and delta < 0.5 then
		return
	end
	throttle[wwise_event_name] = tc:time("main")
    Promise.delay(0.6):next(function() Managers.ui:play_3d_sound("wwise/events/weapon/play_special_sniper_flash", unit_or_position_or_id) end)    
  end)