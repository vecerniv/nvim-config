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

vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini picker diagnostics" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = "Search keymaps" })

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
