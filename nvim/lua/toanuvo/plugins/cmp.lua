local cmp = require 'cmp'
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
