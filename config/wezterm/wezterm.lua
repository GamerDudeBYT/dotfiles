local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.enable_tab_bar = false

config.color_scheme_dirs = { '~/.config/wezterm' }

config.color_scheme = "matugen_theme"

config.font = wezterm.font 'Hurmit Nerd Font'
config.font_size = 15

config.default_prog = { 'fish' }

return config
