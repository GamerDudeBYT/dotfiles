local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.enable_tab_bar = false

config.font = wezterm.font 'Hurmit Nerd Font'
config.font_size = 15

config.default_prog = { 'fish' }

return config
