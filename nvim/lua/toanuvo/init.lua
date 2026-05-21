vim.g.mapleader = " "
vim.g.maplocalleader = "'"


require('toanuvo.plugins')
require('toanuvo.options')
require('toanuvo.keymaps')
require('toanuvo.autocmds')
require('toanuvo.lsp')
require('toanuvo.plugins.cmp')
require('toanuvo.plugins.treesitter')
require('toanuvo.plugins.telescope')



vim.cmd.color("dracula")
