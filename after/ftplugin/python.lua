local format = require("format").stdin(function(buf)
    return { "pyink", "--quiet", "--stdin-filename", vim.api.nvim_buf_get_name(buf), "-" }
end)
vim.keymap.set("n", "<leader>f", format, { buffer = true, desc = "Format with pyink" })
