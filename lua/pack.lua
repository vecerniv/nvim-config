vim.pack.add({
    "https://github.com/rafamadriz/friendly-snippets.git",
    "https://github.com/folke/tokyonight.nvim.git",
    "https://github.com/nvim-mini/mini.nvim.git",
    "https://github.com/nvim-treesitter/nvim-treesitter.git",
    "https://github.com/neovim/nvim-lspconfig.git",
    "https://github.com/mason-org/mason.nvim.git",
    "https://github.com/benomahony/uv.nvim.git"
})

-- nvim-treesitter setup --
require("treesitter")

-- nvim-lsp setup --
require("lsp")

-- mini.starter setup --
require("mini.starter").setup()

-- mini.statusline setup --
require("mini.statusline").setup()

-- mini.icons setup --
local MiniIcons = require("mini.icons")
MiniIcons.setup()
MiniIcons.tweak_lsp_kind() -- icons in mini.completion menu

-- mini.files setup --
local MiniFiles = require("mini.files")
MiniFiles.setup({
    mappings = {
        go_in = "l",
        go_in_plus = "<CR>",
        go_out = "h",
        go_out_plus = "H",
        reset = "r",
        close = "<Esc>",
    },
})

vim.keymap.set("n", "-", function()
    if MiniFiles.close() == nil then
        local path = vim.api.nvim_buf_get_name(0)
        MiniFiles.open(path ~= "" and path or nil) -- unnamed buffer: cwd
    end
end, { desc = "Toggle mini file explorer" })

-- mini.notify setup --
require("mini.notify").setup({
    lsp_progress = { enable = false },
})

-- mini.cmdline setup --
require("mini.cmdline").setup()

-- mini.surround setup --
require("mini.surround").setup()
-- Keymaps
-- 'sa' | add surrounding	  |
-- 'sd' | delete surrounding  |
-- 'sr' | replace surrounding |


-- mini.pick setup --
local MiniPick = require("mini.pick")
MiniPick.setup()

vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini file picker" })
vim.keymap.set("n", "<leader>pw", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
    { desc = "Mini grep word under cursor" })
vim.keymap.set("n", "<leader>pg", function() MiniPick.builtin.grep_live() end, { desc = "Mini live grep" })

-- mini.extra setup --
local MiniExtra = require("mini.extra")
MiniExtra.setup()

vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = "Search keymaps" })

-- general pickers
vim.keymap.set("n", "<leader>pb", function() MiniPick.builtin.buffers() end, { desc = "Pick buffers" })
vim.keymap.set("n", "<leader>ph", function() MiniPick.builtin.help() end, { desc = "Pick help tags" })
vim.keymap.set("n", "<leader>pr", function() MiniPick.builtin.resume() end, { desc = "Resume last picker" })
vim.keymap.set("n", "<leader>po", function() MiniExtra.pickers.oldfiles() end, { desc = "Pick recent files" })
vim.keymap.set("n", "<leader>pl", function() MiniExtra.pickers.buf_lines({ scope = "current" }) end,
    { desc = "Pick lines in buffer" })
vim.keymap.set("n", "<leader>pc", function() MiniExtra.pickers.commands() end, { desc = "Pick commands" })

-- diagnostics
vim.keymap.set("n", "<leader>xb", function() MiniExtra.pickers.diagnostic({ scope = "current" }) end,
    { desc = "Pick buffer diagnostics" })
vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini picker diagnostics" })

-- mini.completion setup --
local MiniCompletion = require("mini.completion")
MiniCompletion.setup({
    lsp_completion = {
        auto_setup = true,
        process_items = function(items, base)
            return MiniCompletion.default_process_items(items, base, {
                kind_priority = { Text = -1, Snippet = 99 }
            })
        end,
    }
})

-- mini.snippets --
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({ snippets = { MiniSnippets.gen_loader.from_lang() } })
MiniSnippets.start_lsp_server()

-- mini.diff setup --
require("mini.diff").setup()

-- mini.git setup --
require("mini.git").setup()

-- mini.trailspace setup --
local MiniTrailspace = require("mini.trailspace")
MiniTrailspace.setup()

vim.keymap.set("n", "<leader>ot", function() MiniTrailspace.trim() end, { desc = "Trim trailspace" })

-- mini.ai setup --
local gen_ai_spec = require("mini.extra").gen_ai_spec
require("mini.ai").setup({
    custom_textobjects = {
        B = gen_ai_spec.buffer(),     -- whole buffer: yaB, daB
        D = gen_ai_spec.diagnostic(), -- diagnostic under cursor
        I = gen_ai_spec.indent(),     -- indent scope
        L = gen_ai_spec.line(),       -- current line
        N = gen_ai_spec.number(),     -- number
    },
})

-- mini.pairs setup --
require("mini.pairs").setup()

-- mini.move setup --
require("mini.move").setup({
    mappings = {
        -- visual mode: J/K move selection up/down, <M-h>/<M-l> move left/right
        down = "J",
        up = "K",
        -- normal mode: <M-j>/<M-k> move the line, <M-h>/<M-l> shift it
    },
})

-- mini.bracketed setup --
require("mini.bracketed").setup()

-- mini.misc setup --
require("mini.misc").setup_restore_cursor()

-- mini.clue setup --
local MiniClue = require("mini.clue")
MiniClue.setup({
    triggers = {
        { mode = { "n", "x" }, keys = "<Leader>" },
        { mode = "n",          keys = "[" },
        { mode = "n",          keys = "]" },
        { mode = "i",          keys = "<C-x>" },
        { mode = { "n", "x" }, keys = "g" },
        { mode = { "n", "x" }, keys = "'" },
        { mode = { "n", "x" }, keys = "`" },
        { mode = { "n", "x" }, keys = '"' },
        { mode = { "i", "c" }, keys = "<C-r>" },
        { mode = "n",          keys = "<C-w>" },
        { mode = { "n", "x" }, keys = "z" },
    },
    clues = {
        -- leader group name setup
        { mode = "n", keys = "<Leader>p", desc = "+Pick" },
        { mode = "n", keys = "<Leader>x", desc = "+Diagnostics" },
        { mode = "n", keys = "<Leader>o", desc = "+Other" },

        MiniClue.gen_clues.square_brackets(),
        MiniClue.gen_clues.builtin_completion(),
        MiniClue.gen_clues.g(),
        MiniClue.gen_clues.marks(),
        MiniClue.gen_clues.registers(),
        MiniClue.gen_clues.windows({ submode_resize = true }),
        MiniClue.gen_clues.z(),
    },
})
