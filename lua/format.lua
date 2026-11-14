local M = {}

--- format the current buffer through stdin -> stdout
function M.stdin(cmd)
    return function()
        local buf = vim.api.nvim_get_current_buf()
        local input = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"
        local res = vim.system(cmd(buf), { stdin = input, text = true }):wait()
        if res.code ~= 0 then
            vim.notify(res.stderr, vim.log.levels.ERROR) -- buffer left untouched
            return
        end
        local lines = vim.split(res.stdout, "\n")
        if lines[#lines] == "" then table.remove(lines) end
        local view = vim.fn.winsaveview()
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.fn.winrestview(view)
    end
end

return M
