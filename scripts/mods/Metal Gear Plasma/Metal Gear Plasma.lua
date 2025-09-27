local mod = get_mod("Metal Gear Plasma")
mod.version = "1.1"

local Audio

mod.on_all_mods_loaded = function()
    mod:info(mod.version)
    Audio = get_mod("Audio")
    if not Audio then 
        mod:echo("Audio mod must be installed and loaded before this one") 
        return
    end
    Audio.hook_sound("wwise/events/weapon/play_minion_plasmapistol_charge", function() 
        Audio.play_file("alert.mp3", { audio_type = "sfx", adelay="500:all=1" })
    end)
end
