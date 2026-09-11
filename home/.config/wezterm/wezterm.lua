local wezterm = require 'wezterm'
return {
	adjust_window_size_when_changing_font_size = false,
	color_scheme = 'Catppuccin Mocha',
	font_size = 14.5,
	font = wezterm.font('Firacode'),
	window_background_opacity = 0.98,
	enable_tab_bar = false,
	mouse_bindings = {
	  {
	    event = { Up = { streak = 1, button = 'Left' } },
	    mods = 'CTRL',
	    action = wezterm.action.OpenLinkAtMouseCursor,
	  },
	},
}
