local set = vim.opt

-- set line numbers
set.nu = true
set.relativenumber = true

set.errorbells = false

set.expandtab = true
set.shiftwidth = 2
set.tabstop = 2
set.softtabstop = 2

set.autoindent = true
set.smartindent = true

set.scrolloff = 3

set.wrap = false

set.cursorline = true

set.clipboard = 'unnamed,unnamedplus'
--set clipboard^=unnamed,unnamedplus

set.smartcase = true
set.swapfile = false
set.backup = false
set.incsearch = true

set.termguicolors = true

set.hidden = true

set.updatetime = 200

set.colorcolumn = "80"

set.cmdheight = 2

set.shortmess:append("c")

set.spell = false
set.spelllang = "en,en_us"

set.list = true
set.listchars = "tab:␉·,trail:·,nbsp:⎵"

set.splitbelow = true
set.splitright = true

vim.g.mapleader = " "

vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'


