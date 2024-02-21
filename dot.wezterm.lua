local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  window:gui_window():maximize()
end)

local config = {
  -- 基本設定
  use_ime = true,
  term = 'xterm-256color',
  font = wezterm.font { family = 'Source Han Code JP', weight = 'Regular', italic = false },
  font_size = 12.0,
  line_height = 1.0,
  enable_scroll_bar = true,
  scrollback_lines = 100000,
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  default_cursor_style = 'BlinkingBlock',
  cursor_blink_rate = 600,
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
  animation_fps = 1,
  audible_bell = 'Disabled',

  window_background_opacity = 0.75,
  window_padding = { left = 2, right = 16, top = 0, bottom = 0 },

  -- カラースキーム設定
  -- color_scheme = 'OneHalfDark',
  -- color_scheme = 'MaterialDark',
  color_scheme = 'Dracula',
  -- color_scheme = 'Material Darker (base16)',
  colors = {
    tab_bar = {
      inactive_tab_edge = '#00a0e4',
      active_tab = {
        bg_color = '#003784', fg_color = '#00a0e4',
        intensity = 'Normal', underline = 'None', italic = false, strikethrough = false,
      },
    },
    scrollbar_thumb = '#003784',
    cursor_bg = '#00a0e4',
    cursor_fg = '#003784',
    cursor_border = '#003784',
  },

  -- ウィンドウフレーム設定
  window_frame = {
    font = wezterm.font { family = 'Meiryo', weight = 'Regular', italic = false },
    font_size = 11.0,
  },

  -- インアクティブペインの外観
  inactive_pane_hsb = { saturation = 0.9, brightness = 0.8, },

  -- キーバインド設定
  keys = {
    { key = '1', mods = 'ALT', action = wezterm.action { ActivateTab = 0 } },
    { key = '2', mods = 'ALT', action = wezterm.action { ActivateTab = 1 } },
    { key = '3', mods = 'ALT', action = wezterm.action { ActivateTab = 2 } },
    { key = '4', mods = 'ALT', action = wezterm.action { ActivateTab = 3 } },
    { key = '5', mods = 'ALT', action = wezterm.action { ActivateTab = 4 } },
    { key = '6', mods = 'ALT', action = wezterm.action { ActivateTab = 5 } },
    { key = '7', mods = 'ALT', action = wezterm.action { ActivateTab = 6 } },
    { key = '8', mods = 'ALT', action = wezterm.action { ActivateTab = 7 } },
    { key = '9', mods = 'ALT', action = wezterm.action { ActivateTab = 8 } },
    { key = '0', mods = 'ALT', action = wezterm.action { ActivateTab = 9 } },
    { key = 'Delete', mods = 'CTRL', action = wezterm.action.SendKey { key = 'd', mods = 'ALT', } },
    { key = 'Backspace', mods = 'CTRL', action = wezterm.action.SendKey { key = 'w', mods = 'CTRL', } },
    { key = 'LeftArrow', mods = 'CTRL', action = wezterm.action.SendKey { key = 'b', mods = 'ALT', } },
    { key = 'RightArrow',mods = 'CTRL', action = wezterm.action.SendKey { key = 'f', mods = 'ALT', } },
    { key = ',', mods = 'CTRL', action = wezterm.action { SpawnCommandInNewWindow = { args = { 'code', os.getenv('HOME') .. '/.wezterm.lua' } } } },
  },

  -- 選択時の単語区切り設定
  selection_word_boundary = " '\"{}[](),",
}

return config
