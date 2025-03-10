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
Plug 'ryanoasis/vim-devicons'
Plug 'dracula/vim' , {'as': 'dracula'}
Plug 'preservim/nerdcommenter'
Plug 'mhinz/vim-startify'
Plug 'windwp/nvim-autopairs'
Plug 'sbulav/nredir.nvim'
Plug 'christoomey/vim-tmux-navigator'
"Plug 'bakpakin/janet.vim'
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
Plug 'mrcjkb/rustaceanvim'
"Plug 'simrat39/rust-tools.nvim'
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
Plug 'nvim-lua/plenary.nvim'
"Plug 'tabbyml/vim-tabby'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
"Plug 'unisonweb/unison', { 'branch': 'trunk', 'rtp': 'editor-support/vim' }

Plug 'mfussenegger/nvim-dap'
"  Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
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

"syntax on
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
"nnoremap <C-b> <C-b>zz

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

autocmd BufWritePre * lua vim.lsp.buf.format()
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
--require('rust-tools').setup{rust_opts}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
--require('lspconfig')['rust-analyzer'].setup {capabilities = capabilities}
local lspconfig = require'lspconfig'
lspconfig.ols.setup{
    root_dir = lspconfig.util.root_pattern("ols.json"),
}
lspconfig.ccls.setup {}
lspconfig.html.setup {capabilities = capabilities}
lspconfig.hls.setup {cmd = {"haskell-language-server-wrapper", "--lsp", "-l hls.log", "-j 1"}}
lspconfig.pyright.setup {}
lspconfig.elmls.setup {}
lspconfig.julials.setup {} 
lspconfig.zls.setup {capabilities = capabilities}
--lspconfig.unison.setup{filetypes = {"unison", "u"}}
lspconfig.gopls.setup{cmd = {"/home/kz/go/bin/gopls"}}
lspconfig.elixirls.setup{cmd = {"elixirls"}}
--lspconfig.racket_langserver.setup{cmd = {"xvfb-run", "racket", "--lib", "racket-langserver"}}
lspconfig.racket_langserver.setup{}
--lspconfig.gleam.setup{}
--lspconfig.tsserver.setup{capabilities = capabilities}
lspconfig.glsl_analyzer.setup{}
--lspconfig.tabby_ml.setup{}

vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr) 
			if client.server_capabilities.inlayHintProvider then
				vim.g.inlay_hints_visible = true
				vim.lsp.inlay_hint.enable(true)
			else
				print("no inlay hints available")
			end
            end,
        settings = {
            ['rust-analyzer'] = {
                capabilities = capabilities
                }
            }
        }
    }


local opts = { noremap=true }
vim.api.nvim_set_keymap('n', '<Leader>nd', ':lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>pd', ':lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>e', ':lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>h', ':lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>u', ':lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gD', ':lua vim.lsp.buf.definition()<CR>', opts)



vim.g.text_object_repeat = false
vim.keymap.set('n', '<leader>tf', function() vim.g.text_object_repeat = not vim.g.text_object_repeat end)

local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set('n', ";", function() 
if(vim.g.text_object_repeat == true) then ts_repeat_move.repeat_last_move_next() 
else vim.cmd("norm! ;") end end,
    opts)
vim.keymap.set('n', ",", function() 
if(vim.g.text_object_repeat) then ts_repeat_move.repeat_last_move_previous()
else vim.cmd("norm! ,") end end,
    opts)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)


local get_root_dir = function() return vim.lsp.get_clients({bufnr=vim.api.nvim_get_current_buf()})[1].root_dir  end

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fc', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>zf', function() builtin.find_files( { cwd = io.popen("zig env | jq -r '.std_dir'"):read("l")}) end, {})
vim.keymap.set('n', '<leader>ff', function() builtin.find_files( { cwd = get_root_dir()}) end, {})

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
        "vimdoc",
        "glsl",
        "odin"
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

--[[
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.zig = {
  install_info = {
    --url = "~/programming/zig/tree-sitter/tree-sitter-zig", -- local path or git repo
    url = "https://github.com/Toanuvo/tree-sitter-zig.git", -- local path or git repo
    revision = "ba8772b57f791f7c91d5687566088fd15fe2834f",
    files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
    -- optional entries:
    branch = "fix-load-hang", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
}
--]]

require("nvim-surround").setup({})

require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
          ["as"] = "@statement.outer",

          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          -- You can optionally set descriptions to the mappings (used in the desc parameter of
          -- nvim_buf_set_keymap) which plugins like which-key display
          -- You can also use captures from other query groups like `locals.scm`
          ["il"] =  {query = "@loop.inner", desc = "select textobjects"},
          ["aa"] =  {query = "@parameter.outer", desc = "select textobjects"},
          ["ia"] =  {query = "@parameter.inner", desc = "select textobjects"},
          ["ay"] = "@parameter.type",
      },

      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      --                             char line    block
      -- mapping query_strings to modes.
      selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@class.outer'] = 'v', -- blockwise
      },

      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = false,
    },

    move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
            --
            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
            ["]o"] = "@loop.*",
            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
            --
            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            ["]s"] = "@statement.outer",
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            ["]a"] = { query = "@parameter.inner",  desc = "Next param" },
        },

        goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
        },
        goto_previous_start = {
            ["[s"] = "@statement.outer",
            ["[a"] = { query = "@parameter.inner",  desc = "Next param" },
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
        },
        goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
        },
        -- Below will go to either the start or the end, whichever is closer.
        -- Use if you want more granular movements
        -- Make it even more gradual by adding multiple queries and regex.
        goto_next = {
            ["]d"] = "@conditional.outer",
        },
        goto_previous = {
            ["[d"] = "@conditional.outer",
        }
        },
    },
}

EOF
