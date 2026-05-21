require 'nvim-treesitter'.setup {
    --[[
    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    indent = {
        enable = true,
        disable = {}
    },

    highlight = {
        enable = true,
        textobjects = { enable = true },
        disable = {},

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },

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
                ["il"] = { query = "@loop.inner", desc = "select textobjects" },
                ["aa"] = { query = "@parameter.outer", desc = "select textobjects" },
                ["ia"] = { query = "@parameter.inner", desc = "select textobjects" },
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
                ['@class.outer'] = 'v',     -- blockwise
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
                ["] ]"] = { query = "@class.outer", desc = "Next class start" },
                --
                -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
                ["]o"] = "@loop.*",
                -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
                --
                -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                ["]s"] = "@statement.outer",
                ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                ["]a"] = { query = "@parameter.inner", desc = "Next param" },
            },

            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[s"] = "@statement.outer",
                ["[a"] = { query = "@parameter.inner", desc = "Next param" },
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
    --]]
}

vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        pcall(vim.treesitter.start)
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- vim.wo.foldmethod = 'expr'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

    --[[
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.zig = {
    install_info = {
        url = "https://github.com/tree-sitter/zig-tree-sitter",
        --url = "~/programming/zig/tree-sitter/tree-sitter-zig", -- local path or git repo
        -- url = "https://github.com/Toanuvo/tree-sitter-zig.git", -- local path or git repo
        -- revision = "ba8772b57f791f7c91d5687566088fd15fe2834f",
        -- files = { "src/parser.c" },                             -- note that some parsers also require src/scanner.c or src/scanner.cc
        -- optional entries:
        -- branch = "fix-load-hang",                               -- default branch in case of git repo if different from master
        -- generate_requires_npm = false,                          -- if stand-alone parser without npm dependencies
        -- requires_generate_from_grammar = false,                 -- if folder contains pre-generated src/parser.c
    },
}
    --]]

local ensureInstalled = {
    "c", "python", "rust", "javascript", "json",
    "julia", "html", "gleam", "java", "cpp",
    "vim", "haskell", "go", "lua", "elm",
    "scala", "zig", "racket", "elixir", "svelte",
    "typescript", "vimdoc", "glsl", "typst", "odin",
}
local alreadyInstalled = require('nvim-treesitter').get_installed()
local parsersToInstall = vim.iter(ensureInstalled)
    :filter(function(parser)
        return not vim.tbl_contains(alreadyInstalled, parser)
    end)
    :totable()
require('nvim-treesitter').install(parsersToInstall)
    :wait(300000)
