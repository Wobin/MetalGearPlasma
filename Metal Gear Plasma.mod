return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Metal Gear Plasma` encountered an error loading the Darktide Mod Framework.")

		new_mod("Metal Gear Plasma", {
			mod_script       = "Metal Gear Plasma/scripts/mods/Metal Gear Plasma/Metal Gear Plasma",
			mod_data         = "Metal Gear Plasma/scripts/mods/Metal Gear Plasma/Metal Gear Plasma_data",
			mod_localization = "Metal Gear Plasma/scripts/mods/Metal Gear Plasma/Metal Gear Plasma_localization",
		})
	end,
	load_after = {
    "DarktideLocalServer",
    "Audio",
  },
  require = {
    "DarktideLocalServer",
    "Audio",
  },
  version = "1.1.0",
	packages = {},
}
