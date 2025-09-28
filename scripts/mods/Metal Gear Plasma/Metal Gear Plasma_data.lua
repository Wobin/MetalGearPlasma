local mod = get_mod("Metal Gear Plasma")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "play_sniper_flash",			
				type = "checkbox",
				default_value = true,
			},
			{
				setting_id = "reduce_noise",			
				type = "checkbox",
				default_value = false,
			},
		}
	}
}
