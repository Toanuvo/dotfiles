local plugpath = vim.fn.expand("~/.config/nvim/plugged")

-- todo vim.pack
vim.cmd("call plug#begin('" .. plugpath .. "')")
vim.cmd([[
  "Plug 'ryanoasis/vim-devicons'
  "Plug 'sbulav/nredir.nvim'
  "Plug 'lervag/vimtex'

  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'mhinz/vim-startify'
  Plug 'windwp/nvim-autopairs'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'm4xshen/hardtime.nvim'

  Plug 'sakhnik/nvim-gdb'
  Plug 'mfussenegger/nvim-dap'
  Plug 'tpope/vim-fugitive'
  Plug 'kylechui/nvim-surround'
  Plug 'neovim/nvim-lspconfig'
  Plug 'mrcjkb/rustaceanvim'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-path'
  Plug 'SirVer/ultisnips'
  Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'reconquest/vim-pythonx'

  Plug 'nvim-lua/lsp_extensions.nvim'
  Plug 'nvim-lua/lsp-status.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '*' }

  Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'main', 'do': ':TSUpdate' }
  "Plug 'nvim-treesitter/nvim-treesitter-textobjects',{ 'branch': 'main'}
  "Plug 'nvim-treesitter/playground'
]])
vim.cmd("call plug#end()")

require("nvim-autopairs").setup({})
require("hardtime").setup({})

local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = ok_cmp and cmp_nvim_lsp.default_capabilities() or nil

local function root_with(marker)
    return function(_, bufnr)
        local path = vim.api.nvim_buf_get_name(bufnr)
        local found = vim.fs.find(marker, { path = path, upward = true })[1]
        return found and vim.fs.dirname(found) or nil
    end
end

if vim.lsp and vim.lsp.config then
    vim.lsp.config("ols", {
        capabilities = capabilities,
        root_dir = root_with("ols.json"),
    })
    vim.lsp.enable("ols")

    vim.lsp.config("tinymist", {
        capabilities = capabilities,
    })
    vim.lsp.enable("tinymist")
end
