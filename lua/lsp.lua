require("mason").setup()

-- mason tool list
local tools = {
    -- LSP servers
    "bash-language-server", "clangd", "foam-language-server", "html-lsp",
    "lua-language-server", "pyright", "texlab", "vale-ls",
    -- linters / formatters
    "shellcheck", "shfmt", "htmlhint", "pyink", "mbake", "tex-fmt", "vale",
}

local registry = require("mason-registry")
registry.refresh(function()
    for _, name in ipairs(tools) do
        local ok, pkg = pcall(registry.get_package, name)
        if ok and not pkg:is_installed() and not pkg:is_installing() then
            pkg:install()
        end
    end
end)

-- enable virtual text for diagnostics
vim.diagnostic.config({
    virtual_text = true,
})

-- append mini.completion capabilities
vim.lsp.config("*", { capabilities = require("mini.completion").get_lsp_capabilities() })

-- LspAttach keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buf = args.buf
        local lsp_pick = function(scope)
            return function() require("mini.extra").pickers.lsp({ scope = scope }) end
        end

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = buf, desc = "Format local buffer" })
        end

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
        vim.keymap.set("n", "<leader>pR", lsp_pick("references"), { buffer = buf, desc = "Pick LSP references" })
        vim.keymap.set("n", "<leader>ps", lsp_pick("document_symbol"), { buffer = buf, desc = "Pick document symbols" })
        vim.keymap.set("n", "<leader>pS", lsp_pick("workspace_symbol_live"),
            { buffer = buf, desc = "Pick workspace symbols" })
        vim.keymap.set("n", "<leader>pi", lsp_pick("implementation"), { buffer = buf, desc = "Pick implementations" })
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
vim.lsp.config("clangd", { filetypes = { "c", "cpp" } })

-- texlab lsp setup --
vim.lsp.config("texlab", {
	settings = {
		texlab = {
			latexFormatter = "tex-fmt",
			build = {
				executable = "latexmk",
				args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-file-line-error", "%f" },
				useFileList = true,
			},
		},
	},
})

-- vale lsp setup
vim.lsp.config("vale_ls", {
    filetypes = { "markdown", "text", "rst" }, -- exclude: tex/html/xml//asciidoc
    init_options = { syncOnStartup = true },
})

-- enable all of this shit
vim.lsp.enable({
    "bashls", "clangd", "foam_ls", "html",
    "lua_ls", "pyright", "texlab", "vale_ls",
})
