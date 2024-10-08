local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 13

config.enable_scroll_bar = false
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"
config.colors = {
	background = "#1c1c1c",
}

--[[ config.macos_window_background_blur = 10
config.window_background_opacity = 0.8 ]]

return config
