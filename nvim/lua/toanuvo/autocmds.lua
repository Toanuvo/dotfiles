local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  pattern = "netrw",
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "h", "-", opts)
    vim.keymap.set("n", "l", "<CR>", opts)
    vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
    vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
    vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
    vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
  end,
})

autocmd("FileType", {
  pattern = { "j", "racket" },
  callback = function()
    vim.opt_local.tabstop = 2
  end,
})

autocmd("FileType", {
  pattern = "c",
  callback = function(ev)
    vim.keymap.set("n", "<Leader>r", "<Esc>:w<CR>:make clean<CR>:make run<CR>", { buffer = ev.buf })
  end,
})

autocmd("FileType", {
  pattern = "python",
  callback = function(ev)
    vim.keymap.set("n", "<Leader>r", "<Esc>:w<CR>:!python %<CR>", { buffer = ev.buf })
  end,
})

autocmd("FileType", {
  pattern = "rust",
  callback = function(ev)
    vim.keymap.set("n", "<Leader>r", "<Esc>:w<CR>:!cargo run<CR>", { buffer = ev.buf })
  end,
})

autocmd("FileType", {
  pattern = "autohotkey",
  callback = function(ev)
    vim.keymap.set("n", "<Leader>r", ":w<CR>:call jobstart(expandcmd('%:p'))<CR>", { buffer = ev.buf })
  end,
})

autocmd("FileType", {
  pattern = "zig",
  callback = function(ev)
    vim.keymap.set("n", "<Leader>p", "<Esc>ostd.debug.print(\"{any}\\n\", .{});<C-o>2h", { buffer = ev.buf })
  end,
})

autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format()
  end,
})

autocmd({ "BufWinEnter", "WinEnter" }, {
  pattern = "term://*",
  command = "startinsert",
})

autocmd("BufWritePost", {
  pattern = { "*.typ", "*.typst" },
  callback = function()
    vim.fn.jobstart({ "typst", "compile", vim.api.nvim_buf_get_name(0) })
  end,
})

local ok, commhl = pcall(vim.api.nvim_get_hl, 0, { name = "Comment" })
if ok then
  vim.api.nvim_set_hl(0, "LspInlayHint", { italic = true, fg = commhl.fg, bg = "bg" })
end

autocmd("LspAttach", {
  group = augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
  end,
})

vim.api.nvim_create_user_command("Explore", "Vexplore", {})

vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("split")
  vim.cmd("noswapfile hide enew")
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "hide"
  vim.cmd("file scratch")
end, {})
