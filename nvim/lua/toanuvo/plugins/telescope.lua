require('telescope').setup {}

local get_root_dir = function() 
    local client = vim.lsp.get_clients({bufnr=vim.api.nvim_get_current_buf()})[1]
    if(client == nil) then 
        return vim.loop.cwd() 
    else
        return client.root_dir
    end
end


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fc', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>zf', function() builtin.find_files( { cwd = io.popen("zig env | jq -r '.std_dir'"):read("l")}) end, {})
vim.keymap.set('n', '<leader>ff', function() builtin.find_files( { cwd = get_root_dir()}) end, {})
