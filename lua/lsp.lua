require("mason").setup()
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

vim.diagnostic.config({
	virtual_text = true,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

-- Buffer-local LSP keymaps via LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local buf = args.buf
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = buf, desc = "Format local buffer" })
	end,
})

-- lua lsp setup --
vim.lsp.config("lua_ls", {
	root_markers = { ".luarc.json", ".git" },
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

-- pyright lsp setup --
vim.lsp.config("pyright", {
	-- nearest uv project, otherwise the script's own directory
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		on_dir(vim.fs.root(fname, { "pyproject.toml", "uv.lock" }) or vim.fs.dirname(fname))
	end,
	-- nearest .venv walking upward (uv's discovery order)
	before_init = function(_, config)
		local venv = vim.fs.find(".venv", {
			path = config.root_dir,
			upward = true,
			type = "directory",
		})[1]
		if venv then
			config.settings.python = config.settings.python or {}
			config.settings.python.pythonPath = vim.fs.joinpath(venv, "bin", "python")
		end
	end,
})

-- clangd lsp setup --
vim.lsp.config("clangd", {
	cmd = { "clangd", "--background-index" },
	filetypes = { "c", "cpp" },
	root_markers = { "compile_commands.json", ".git" },
})

vim.lsp.enable({
	"lua_ls",
	"clangd",
	"pyright",
	"bashls",
})
