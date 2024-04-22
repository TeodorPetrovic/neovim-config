local opt = vim.opt

-- Show relative number on the side and on current line show current line
opt.relativenumber = true
opt.number = true

-- Configure tabs and indentation
opt.tabstop = 2 -- 4 spaces for tabs
opt.shiftwidth = 2 -- 4 spaces indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting a new one

opt.wrap = true

-- Configure Search Settings
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- It asumes if you type in mixed case that you want case sencitive

opt.cursorline = true

-- ColourScheme configuration
-- opt.termguicolors = true
-- opt.background = "dark" -- Colorscheme converts all background colors to black (regardless of theme)
-- opt.signcolumn = "yes" -- Show sign column so that text does not shift (I don't know what this means) This is hte bar on the left side nad the highlight

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split Windows
opt.splitright = true -- split vertical windows to the right
opt.splitbelow = true -- split vertical windows to the left

