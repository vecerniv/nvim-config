local treesitter = require("nvim-treesitter")

local ensure_installed = {
    -- languages
    "cpp", "bash", "python", "latex", "foam",
    -- extras
    "http",
}

treesitter.install(ensure_installed)

local no_ts_indent = { python = true }

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not (lang and vim.treesitter.language.add(lang)) then return end
        vim.treesitter.start(args.buf, lang)
        if not no_ts_indent[lang] and vim.treesitter.query.get(lang, "indents") then
            if vim.treesitter.query.get(lang, "indents") then
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
    end,
})
