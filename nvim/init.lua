require('toanuvo')

local normhl = vim.api.nvim_get_hl(0, { name = "Normal" })
local commhl = vim.api.nvim_get_hl(0, { name = "Comment" })
-- vim.api.nvim_set_hl(0, "DraculaInlayHint", { foreground = commhl["foreground"], bg = "bg" })
vim.api.nvim_set_hl(0, "LspInlayHint", {
    italic = false,
    fg = commhl.fg,
    bg = normhl.bg,
    ctermfg = commhl.ctermfg,
    ctermbg = normhl.ctermbg,
    guifg = commhl.guifg,
    guibg = normhl.guibg,
})
