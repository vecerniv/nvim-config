require("mason").setup()

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

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = buf, desc = "Format local buffer" })

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

-- lsp enable
vim.lsp.enable({
    "lua_ls",
    "clangd",
    "pyright",
    "bashls",
})
