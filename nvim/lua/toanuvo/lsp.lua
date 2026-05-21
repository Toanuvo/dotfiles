-- Enable inlay hints globally for all LSP servers
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end
    end,
})

local commhl = vim.api.nvim_get_hl_by_name("comment", true)
--vim.api.nvim_set_hl(0, "DraculaInlayHint", { foreground=commhl["foreground"],  background="bg" })
vim.api.nvim_set_hl(0, "LspInlayHint", { italic = true, fg = commhl["foreground"], bg = "bg" })

local capabilities = require('cmp_nvim_lsp').default_capabilities()


vim.lsp.config('html', { capabilities = capabilities })
vim.lsp.config('zls', { capabilities = capabilities })
vim.lsp.config('hls', {
    cmd = { "haskell-language-server-wrapper", "--lsp", "--log-client=True", "--log-stderr=False" } })
vim.lsp.config('gopls', { cmd = { "/home/kz/go/bin/gopls" } })
vim.lsp.config('elixirls', { cmd = { "elixirls" } })
--vim.lsp.unison.setup{filetypes = {"unison", "u"}}
--vim.lsp.racket_langserver.setup{cmd = {"xvfb-run", "racket", "--lib", "racket-langserver"}}
-- vim.lsp.enable('racket_langserver')
--vim.lsp.tsserver.setup{capabilities = capabilities}
-- vim.lsp.enable('texlab')
--vim.lsp.enable('tabby_ml')

vim.lsp.config('lua_ls', {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
                    vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
                },
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = vim.api.nvim_get_runtime_file('', true),
            },
        })
    end,
    settings = {
        Lua = {},
    },
})


vim.lsp.enable('tinymist')
vim.lsp.enable('ccls')
vim.lsp.enable('pyright')
-- vim.lsp.enable('elmls')
vim.lsp.enable('julials')
vim.lsp.enable('glsl_analyzer')
vim.lsp.enable('gleam')
vim.lsp.enable('zls')
vim.lsp.enable('lua_ls')

local map = vim.keymap.set
map('n', '<Leader>nd', vim.diagnostic.goto_next, opts)
map('n', '<Leader>pd', vim.diagnostic.goto_prev, opts)
map('n', '<Leader>e', vim.diagnostic.open_float, opts)
map('n', '<Leader>h', vim.lsp.buf.hover, opts)
map('n', '<Leader>u', vim.lsp.buf.references, opts)
map('n', 'gD', vim.lsp.buf.definition, opts)

vim.cmd [[ autocmd BufWritePre * lua vim.lsp.buf.format() ]]

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
