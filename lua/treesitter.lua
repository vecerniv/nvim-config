local treesitter = require("nvim-treesitter")

local ensure_installed = {
	-- languages
	 "cpp", "bash", "python", "latex", "foam",
	-- extras
	"http",
}

treesitter.install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if not (lang and vim.treesitter.language.add(lang)) then return end
        vim.treesitter.start(args.buf, lang)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
	end,
})

