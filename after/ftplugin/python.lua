local function pyink_format()
    local buf = vim.api.nvim_get_current_buf()
    local input = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"
    local res = vim.system(
        { "pyink", "--quiet", "--stdin-filename", vim.api.nvim_buf_get_name(buf), "-" },
        { stdin = input, text = true }
    ):wait()

    if res.code ~= 0 then
        vim.notify(res.stderr, vim.log.levels.ERROR)
        return
    end

    local lines = vim.split(res.stdout, "\n")
    if lines[#lines] == "" then table.remove(lines) end

    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.fn.winrestview(view)
end

vim.keymap.set("n", "<leader>f", pyink_format, { buffer = true, desc = "Format with pyink" })
