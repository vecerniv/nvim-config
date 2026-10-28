vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>re", "<cmd>restart<cr>", { desc = "Restart Neovim" })

vim.keymap.set("x", "p", "P", { desc = "Paste over selection without yanking the text" })
vim.keymap.set({ "n", "v" }, "<Leader>d", [["_d]], { desc = "Delete without yanking" })

-- Ctrl-c setup - escape insert
vim.keymap.set("i", "<C-c>", "<Esc>")

-- better selection indentation
vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

-- better page scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up in buffer with cursor centered" })

-- better search
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search results cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search results cursor centered" })
