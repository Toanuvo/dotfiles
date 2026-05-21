vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.showcmd = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.autochdir = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.clipboard = "unnamedplus"
vim.opt.guifont = "RobotoMono:h16"

vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = -25
vim.g.netrw_banner = 0

vim.g.startify_lists = {
    { type = "commands",  header = { "   Commands" } },
    { type = "bookmarks", header = { "   Bookmarks" } },
    { type = "files",     header = { "   MRU" } },
    { type = "dir",       header = { "   MRU " .. vim.fn.getcwd() } },
    { type = "sessions",  header = { "   Sessions" } },
}
vim.g.startify_bookmarks = {
    "~/.config/nvim/init.lua",
    "~\\AppData\\Local\\nvim\\init.lua",
    "$USERPROFILE\\",
}
vim.g.startify_commands = { "term" }
vim.g.startify_custom_header = ""
vim.g.startify_session_persistence = 1

vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips", "mysnips" }
