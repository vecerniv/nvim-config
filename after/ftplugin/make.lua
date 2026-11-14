local format = require("format").stdin(function() return { "mbake", "format", "--stdin" } end)
vim.keymap.set("n", "<leader>f", format, { buffer = true, desc = "Format with mbake" })
