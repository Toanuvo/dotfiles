local map = vim.keymap.set


map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
-- map("n", "<C-c>", ":cd %:p:h<CR>")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-f>", "<C-f>zz")
-- map("n", "<C-b>", "<C-b>zz")

map("n", "<Leader>R", ":w<CR>:source %<CR>")
map("n", "<Leader>s", ":w<CR>")
map("n", "<Leader>w", ":qa<CR>")
map("n", "<Leader>v", ":vs ")
map("n", "<Leader>tw", ":set invwrap<CR>")
map("n", "<Leader>tp", ":set invpaste<CR>")
map("n", "<Leader>th", ":set invhlsearch<CR>")
map("n", "<Leader>o", ":Startify<CR>")

map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "J", "mpJ`p")
map("n", ":h", ":vert h")
map("n", "yp", ":let @\" = expand(\"%:p\")<CR>")
-- map("n", "gb", ":ls<CR>:b<Space>")
map("n", "k", function()
    return (vim.v.count > 5 and "m'" .. vim.v.count or "") .. "k"
end, { expr = true })
map("n", "j", function()
    return (vim.v.count > 5 and "m'" .. vim.v.count or "") .. "j"
end, { expr = true })

map("t", "<C-R>", function()
  return '<C-\\><C-N>"' .. vim.fn.nr2char(vim.fn.getchar()) .. "pi"
end, { expr = true })
map("t", "jk", "<C-\\><C-n>")
map("t", "<C-h>", "<C-\\><C-n><C-w>h")
map("t", "<C-j>", "<C-\\><C-n><C-w>j")
map("t", "<C-k>", "<C-\\><C-n><C-w>k")
map("t", "<C-l>", "<C-\\><C-n><C-w>l")
map("t", "<Esc>", "<C-\\><C-n>")

map("i", "jk", "<Esc>")
map("i", "<C-H>", "<C-o>h")
map("i", "<C-l>", "<C-o>l")
map("i", "<C-e>", "<Esc>A;<Esc>")
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")

map("v", "q", "<Esc>:q<CR>")
map("v", "<Leader>w", "<Esc>:q<CR>")
