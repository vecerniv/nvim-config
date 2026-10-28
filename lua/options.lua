vim.o.nu = true
vim.o.relativenumber = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.laststatus = 3

vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true

vim.opt.clipboard:append("unnamedplus")

vim.o.guicursor = ""
vim.o.wrap = false
vim.o.updatetime = 250
vim.o.inccommand = "split"

vim.o.scrolloff = 8
vim.o.colorcolumn = "0"
vim.o.signcolumn = "yes"
vim.o.cmdheight = 0

vim.o.completeopt = "menuone,noselect,fuzzy,nosort"
vim.opt.shortmess:append("c")

vim.o.foldlevelstart = 99

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	callback = function()
		vim.hl.on_yank()
	end,
})
