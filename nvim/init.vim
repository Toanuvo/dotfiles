let OS = luaeval('jit.os')
echo OS
if OS == 'Linux'
	let plugpath = '~/.config/nvim/plugged'
else 
	let plugpath = '~\AppData\Local\nvim\plugged'
    let g:python3_host_prog = '$PYTHON_PATH'
    
    "lua vim.o.shell = "\"C:/Program Files/PowerShell/7-preview/pwsh.exe\"" 
endif

call plug#begin(plugpath)
Plug 'dracula/vim'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdcommenter'
Plug 'mhinz/vim-startify'
Plug 'windwp/nvim-autopairs'
Plug 'sbulav/nredir.nvim'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'roxma/nvim-yarp'
" Plug 'roxma/vim-hug-neovim-rpc'
"  Plug 'scrooloose/nerdtree'
"  Plug 'vim-airline/vim-airline-themes'
"  Plug 'vim-airline/vim-airline'
"  Plug 'kyazdani42/nvim-web-devicons'

Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-cmdline'
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

Plug 'mfussenegger/nvim-dap'
"  Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
call plug#end()

let mapleader = " "

"syntax on

colorscheme dracula

set mouse=a
set splitright
set splitbelow
set noshowmode
set wildmenu
set wildignorecase
set showcmd
"set path+=**
set clipboard+=unnamedplus
set number
set relativenumber
set guifont=RobotoMono\ NF:h13
"set guifont=Segoe\ UI:h13
set expandtab
set autoindent
set tabstop=4
set shiftwidth=0

filetype on
filetype plugin on
filetype indent on

let g:netrw_browse_split = 4
let g:netrw_winsize = -25
let g:netrw_banner = 0
set autochdir
au FileType netrw nmap <buffer> h -
au FileType netrw nmap <buffer> l <CR>
au FileType netrw nmap <buffer> <C-h> <C-w>h
au FileType netrw nmap <buffer> <C-j> <C-w>j
au FileType netrw nmap <buffer> <C-k> <C-w>k
au FileType netrw nmap <buffer> <C-l> <C-w>l

au FileType j set tabstop=2

au FileType c           nnoremap <buffer> <Leader>r <Esc>:w<CR>:make clean<CR>:make run<CR>
au FileType python      nnoremap <buffer> <Leader>r <Esc>:w<CR>:!python %<CR>
au FileType rust        nnoremap <buffer> <Leader>r <Esc>:w<CR>:!cargo run<CR>
au FileType autohotkey  nnoremap <buffer> <Leader>r :w<CR>:call jobstart(expandcmd('%:p'))<CR>

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


nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-c> :cd %:p:h<CR>

nnoremap <Leader>R :w<CR>:source %<CR>
nnoremap <Leader>s :w<CR>
nnoremap <Leader>w :qa<CR>
nnoremap <Leader>v :vs 
nnoremap <Leader>t <C-w>v:term<CR>

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
require('rust-tools').setup({})
require('nvim-autopairs').setup{}

local lspconfig = require'lspconfig'
lspconfig.ccls.setup {}

local opts = { noremap=true }
vim.api.nvim_set_keymap('n', '<Leader>h', ':lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

END

lua << END
local cmp = require'cmp'

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
                ["<Tab>"] = function(fallback)
                        if cmp.visible() then
                                cmp.select_next_item()
                        else
                                fallback()
                        end
                end,
                ["<S-Tab>"] = function(fallback)
                        if cmp.visible() then
                                cmp.select_prev_item()
                        else
                                fallback()
                        end
                end,
        },
        sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'ultisnips' }, -- For ultisnips users.
                { name = 'buffer' }
        })
})

--cmp.setup.cmdline(':', { sources = cmp.config.sources({ {name = 'path'}, {name = 'cmdline'} }) })
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
--require('lspconfig')['rust-analyzer'].setup {capabilities = capabilities}
END

lua <<EOF
require'nvim-treesitter.configs'.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
ensure_installed = {
    "c",
    "python",
    "rust",
    "javascript",
    "json",
    "html",
    "java",
    "cpp",
    "vim",
    "lua"
},

-- Install languages synchronously (only applied to `ensure_installed`)
sync_install = false,

indent = {
    enable = true,
    disable = {}
    },

highlight = {
    enable = true,
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
    }
}
EOF
