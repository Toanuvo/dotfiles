let OS = luaeval('jit.os')
echo OS
if OS == 'Linux'
	let plugpath = '~/.config/nvim/plugged'
else 
	let plugpath = '~\AppData\Local\nvim\plugged'
    let g:python3_host_prog = '$PYTHON_PATH'
    
    "lua vim.o.shell = "\"C:/Program Files/PowerShell/7-preview/pwsh.exe\"" 
endif

lua <<END
require('init')
END

call plug#begin(plugpath)
Plug 'dracula/vim'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdcommenter'
Plug 'mhinz/vim-startify'
Plug 'windwp/nvim-autopairs'
Plug 'sbulav/nredir.nvim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'bakpakin/janet.vim'
" Plug 'roxma/nvim-yarp'
" Plug 'roxma/vim-hug-neovim-rpc'
"  Plug 'scrooloose/nerdtree'
"  Plug 'vim-airline/vim-airline-themes'
"  Plug 'vim-airline/vim-airline'
"  Plug 'kyazdani42/nvim-web-devicons'
Plug 'takac/vim-hardtime'
Plug 'sakhnik/nvim-gdb'
Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-surround'
Plug 'kylechui/nvim-surround'
Plug 'neovim/nvim-lspconfig'
"todo Plug 'mrcjkb/rustaceanvim'
Plug 'simrat39/rust-tools.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-cmdline'
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'honza/vim-snippets'
Plug 'reconquest/vim-pythonx'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/lsp-status.nvim'
"Plug 'unisonweb/unison', { 'branch': 'trunk', 'rtp': 'editor-support/vim' }

Plug 'mfussenegger/nvim-dap'
"  Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
"  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
call plug#end()

let mapleader = " "

" hardtime config
let g:hardtime_default_on = 1
let g:hardtime_maxcount = 3
let g:hardtime_motion_with_count_resets = 1
let g:hardtime_timeout = 2000

colorscheme dracula

" syntax on
"set mouse=a
"set splitright
"set splitbelow
"set wildmenu
"set wildignorecase
"set showcmd
"set path+=**
"set clipboard+=unnamedplus
"set number
"set relativenumber
"set guifont=RobotoMono\ NF:h13
"set guifont=Segoe\ UI:h13
"set expandtab
"set autoindent
"set tabstop=4
"set shiftwidth=0
"set autochdir

filetype on
filetype plugin on
filetype indent on

let g:netrw_browse_split = 4
let g:netrw_winsize = -25
let g:netrw_banner = 0
au FileType netrw nmap <buffer> h -
au FileType netrw nmap <buffer> l <CR>
au FileType netrw nmap <buffer> <C-h> <C-w>h
au FileType netrw nmap <buffer> <C-j> <C-w>j
au FileType netrw nmap <buffer> <C-k> <C-w>k
au FileType netrw nmap <buffer> <C-l> <C-w>l

au FileType j set tabstop=2
au FileType racket set tabstop=2

au FileType c           nnoremap <buffer> <Leader>r <Esc>:w<CR>:make clean<CR>:make run<CR>
au FileType python      nnoremap <buffer> <Leader>r <Esc>:w<CR>:!python %<CR>
au FileType rust        nnoremap <buffer> <Leader>r <Esc>:w<CR>:!cargo run<CR>
au FileType autohotkey  nnoremap <buffer> <Leader>r :w<CR>:call jobstart(expandcmd('%:p'))<CR>

au FileType zig         nnoremap <buffer> <Leader>p <Esc>ostd.debug.print("{any}\n", .{});<C-o>2h

" startify stuff
let g:startify_lists = [
  \ { 'type': 'commands',  'header': ['   Commands']       },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ ]
let g:startify_bookmarks = ['~/.config/nvim/init.vim', '~\AppData\Local\nvim\init.vim' ,'$USERPROFILE\']
let g:startify_commands = ['term']
let g:startify_custom_header = ''
let g:startify_session_persistence = 1

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "mysnips"]

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-c> :cd %:p:h<CR>
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz

nnoremap <Leader>R :w<CR>:source %<CR>
nnoremap <Leader>s :w<CR>
nnoremap <Leader>w :qa<CR>
nnoremap <Leader>v :vs 
"nnoremap <Leader>t <C-w>v:term<CR>
nnoremap <Leader>tw :set invwrap<CR>
nnoremap <Leader>tp :set invpaste<CR>
nnoremap <Leader>th :set invhlsearch<CR>
nnoremap <Leader>o :Startify<CR>
"nnoremap <Leader>e :e<CR>
nnoremap <Leader>l iλ


nnoremap n nzz
nnoremap N Nzz
nnoremap J mpJ`p
nnoremap :h :vert h
nnoremap yp :let @" = expand("%:p")<CR>
nnoremap gb :ls<CR>:b<Space>
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'


autocmd BufWinEnter,WinEnter term://* startinsert
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
tnoremap jk <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
tnoremap <Esc> <C-\><C-n>

inoremap jk <Esc>
inoremap <C-H> <C-o>h
inoremap <C-l> <C-o>l
inoremap <C-e> <Esc>A;<Esc>
inoremap , ,<c-g>u
inoremap . .<c-g>u


"autocmd CursorMoved,InsertLeave,TabEnter,BufWritePost * :lua require'lsp_extensions'.inlay_hints{ prefix = '=>', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

vnoremap q <Esc>:q<CR>
vnoremap <Leader>w <Esc>:q<CR>

command! Explore Vexplore

function! Scratch()
        split
        noswapfile hide enew
        setlocal buftype=nofile
        setlocal bufhidden=hide
        "    "lcd ~
        file scratch
endfunction

lua <<END

local rust_opts = { 
    tools = {
        autoSetHints = true,
        inlayHints = {
            parameterHints = true,
            typeHints = {
                enable = true
                }, 
            parameter_hints_prefix = "",
            other_hints_prefix = "",
            }
        }
    }

require('nvim-autopairs').setup{}
require('rust-tools').setup{rust_opts}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
--require('lspconfig')['rust-analyzer'].setup {capabilities = capabilities}
local lspconfig = require'lspconfig'
lspconfig.ccls.setup {}
lspconfig.html.setup {capabilities = capabilities}
lspconfig.hls.setup {cmd = {"haskell-language-server-wrapper", "--lsp", "-l hls.log", "-j 1"}}
lspconfig.pyright.setup {}
lspconfig.elmls.setup {}
lspconfig.julials.setup {} 
lspconfig.zls.setup {capabilities = capabilities}
--lspconfig.unison.setup{filetypes = {"unison", "u"}}
lspconfig.gopls.setup{cmd = {"/home/kz/go/bin/gopls"}}
lspconfig.elixirls.setup{cmd = {"/home/kz/programming/elixir/bin/lsp/language_server.sh"}}
--lspconfig.racket_langserver.setup{cmd = {"xvfb-run", "racket", "--lib", "racket-langserver"}}
lspconfig.racket_langserver.setup{}
lspconfig.gleam.setup{}
lspconfig.tsserver.setup{capabilities = capabilities}

--lspconfig.rust_analyzer.setup {}


local opts = { noremap=true }
vim.api.nvim_set_keymap('n', '<Leader>nd', ':lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>pd', ':lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>e', ':lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>h', ':lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>u', ':lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gD', ':lua vim.lsp.buf.definition()<CR>', opts)

-- vim.filetype.add({extension = { pony = 'pony' }})


local cmp = require'cmp'
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

cmp.setup({
        snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
                },
        mapping = {
                ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                ['<C-e>'] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                }),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items. 
				["<Tab>"] = cmp.mapping(
					function(fallback)
					cmp_ultisnips_mappings.jump_forwards(fallback)
					end,
					{ "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
				),
				["<S-Tab>"] = cmp.mapping(
					function(fallback)
					cmp_ultisnips_mappings.jump_backwards(fallback)
					end,
					{ "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
				),
                ["<down>"] = function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end,
                ["<up>"] = function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end,
        },
        sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'ultisnips' }, -- For ultisnips users.
                { name = 'buffer' }
        })
})
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
'confirm_done',
cmp_autopairs.on_confirm_done()
)

--cmp.setup.cmdline(':', { sources = cmp.config.sources({ {name = 'path'}, {name = 'cmdline'} }) })



END

lua <<EOF
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.pony = {
    install_info = {
        url = "~/programming/pony/tree-sitter-ponylang", -- local path or git repo
        files = {"src/parser.c", "src/scanner.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
        -- optional entries:
        branch = "main", -- default branch in case of git repo if different from master
        generate_requires_npm = false, -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
        },
        filetype = "pony", -- if filetype does not match the parser name
}

--require("vim.treesitter.query").set("pony", "injections", "(method name: (identifier) @function)")


--require'nvim-treesitter.install'.compilers = {"zig c++"}
require'nvim-treesitter.configs'.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = {
        "c",
        "python",
        "rust",
        "javascript",
        "json",
        "julia",
        "html",
        "gleam",
        "java",
        "cpp",
        "vim",
        "haskell",
        "go",
        "lua",
        "elm",
        "scala",
        "zig",
        "racket",
        "elixir",
        "svelte",
        "typescript",
        --"pony",
        "vimdoc"
    },

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    indent = {
        enable = true,
        disable = {}
    },

    highlight = {
        enable = true,
        textobjects = {enable = true},
        disable = {},

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    }

}
require("nvim-surround").setup({})


EOF
