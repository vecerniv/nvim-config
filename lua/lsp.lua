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

vim.lsp.config("lua_ls", {
	root_markers = { ".luarc.json", ".git" },
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

-- Dynamic venv detection for uv compatibility
local function get_python_path(workspace)
	local venv_python = workspace .. "/.venv/bin/python"
	if vim.fn.filereadable(venv_python) == 1 then
		return venv_python
	end
	return "python3"
end

vim.lsp.config("pyright", {
	root_markers = { "pyproject.toml", "setup.py", ".git" },
	on_init = function(client)
		local workspace = client.workspace_folders
			and client.workspace_folders[1]
			and client.workspace_folders[1].name
			or vim.fn.getcwd()
		client.config.settings = client.config.settings or {}
		client.config.settings.python = client.config.settings.python or {}
		client.config.settings.python.pythonPath = get_python_path(workspace)
		client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		return true
	end,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
})

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
