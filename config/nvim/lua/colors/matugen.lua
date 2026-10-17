-- Matugen theme for mini.base16

local base16 = require('mini.base16')
local shared = require('colors._shared')

local diff_palette = {
  add    = { bg = '#c66dda', fg = '#000000' },
  delete = { bg = '#93000a',    fg = '#ffdad6' },
  change = { bg = '#4d8efe' },
  text   = { bg = '#344972' },
}

-- Base16 palette from matugen
local palette = {
  base00 = '#11131a', -- background
  base01 = '#11131a', -- lighter background
  base02 = '#11131a', -- selection
  base03 = '#424753', -- comments, line numbers
  base04 = '#c2c6d5', -- dark foreground
  base05 = '#e1e2eb', -- foreground
  base06 = '#f0f1f5', -- light foreground
  base07 = '#ffffff', -- lightest
  base08 = '#ffb4ab', -- red (variables, errors)
  base09 = '#83a4f2', -- orange
  base0A = '#b1c6f7', -- yellow
  base0B = '#f4aeff', -- green (strings)
  base0C = '#d8e2ff', -- cyan (operators)
  base0D = '#adc6ff', -- blue (functions)
  base0E = '#fdd6ff', -- purple (keywords)
  base0F = '#ffcbc5', -- brown
}

base16.setup({
  palette = palette,
  use_cterm = nil,
  plugins = {
    default = true,
    ['echasnovski/mini.nvim'] = true,
  },
})

vim.g.colors_name = 'matugen'

-- Custom highlight colors
local colors = {
  white = '#e1e2eb',
  darker_black = '#1d2026',
  black = '#111319',
  black2 = '#11131a',
  one_bg = '#11131a',
  grey = '#424753',
  red = '#ffb4ab',
  pink = '#fdd6ff',
  green = '#f4aeff',
  blue = '#adc6ff',
  orange = '#83a4f2',
  cyan = '#f2f5ff',
  teal = '#d8e2ff',
  purple = '#fcbdff',
  lavender = '#ffffff',
}

local function apply_custom_highlights()
  -- UI highlights
  vim.api.nvim_set_hl(0, 'Normal', { bg = colors.black })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = colors.darker_black })
  vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = colors.darker_black })
  vim.api.nvim_set_hl(0, 'NvimTreeNormalNC', { bg = colors.darker_black })
  vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = colors.darker_black })
  vim.api.nvim_set_hl(0, 'TelescopePrompt', { bg = colors.darker_black })
  vim.api.nvim_set_hl(0, 'TelescopeResults', { bg = colors.darker_black })
  vim.api.nvim_set_hl(0, 'Pmenu', { bg = colors.black2 })
  vim.api.nvim_set_hl(0, 'CmpPmenu', { bg = colors.black2 })
  vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = colors.black2 })
  vim.api.nvim_set_hl(0, 'Visual', { bg = colors.grey })
  vim.api.nvim_set_hl(0, 'VisualNOS', { bg = colors.grey })

  -- Treesitter highlights
  vim.api.nvim_set_hl(0, '@variable', { fg = colors.white })
  vim.api.nvim_set_hl(0, '@module', { fg = colors.white })
  vim.api.nvim_set_hl(0, '@variable.member', { fg = colors.white })
  vim.api.nvim_set_hl(0, '@property', { fg = colors.teal })
  vim.api.nvim_set_hl(0, '@variable.builtin', { fg = colors.red })
  vim.api.nvim_set_hl(0, '@type.builtin', { fg = colors.purple })
  vim.api.nvim_set_hl(0, '@variable.parameter', { fg = colors.orange })
  vim.api.nvim_set_hl(0, '@operator', { fg = colors.cyan })
  vim.api.nvim_set_hl(0, '@punctuation.delimiter', { fg = colors.cyan })
  vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = colors.cyan })
  vim.api.nvim_set_hl(0, '@punctuation.special', { fg = colors.teal })
  vim.api.nvim_set_hl(0, '@function.macro', { fg = colors.pink })
  vim.api.nvim_set_hl(0, '@keyword.storage', { fg = colors.purple })
  vim.api.nvim_set_hl(0, '@tag.delimiter', { fg = colors.cyan })
  vim.api.nvim_set_hl(0, '@function', { fg = colors.blue })
  vim.api.nvim_set_hl(0, '@constructor', { fg = colors.lavender })
  vim.api.nvim_set_hl(0, '@tag.attribute', { fg = colors.orange })

  -- Syntax highlights
  vim.api.nvim_set_hl(0, 'StorageClass', { fg = colors.purple })
  vim.api.nvim_set_hl(0, 'Repeat', { fg = colors.purple })
  vim.api.nvim_set_hl(0, 'Define', { fg = colors.blue })

  shared.apply_diff(diff_palette)

  -- Telescope custom
  vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = colors.one_bg, fg = colors.blue })
end

apply_custom_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = apply_custom_highlights,
})

return {
  palette = palette,
  colors = colors,
}
