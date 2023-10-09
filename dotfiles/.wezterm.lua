-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- Standard color & font for me
config.color_scheme = 'Snazzy'
config.font = wezterm.font 'Go Mono'
config.font_size = 11.0
config.window_background_opacity = 0.93
config.colors = {
	cursor_bg = 'red',
	cursor_fg = 'red',
	cursor_border = 'red',
}

-- Remove ugly defaults
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Prompt char looks kooky, so use a different one.
config.set_environment_variables = { PURE_PROMPT_SYMBOL = ">" }

-- Also standard cursor
config.cursor_blink_rate = 400
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- Tab bar - at bottom and not over-designed
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- and finally, return the configuration to wezterm
return config

