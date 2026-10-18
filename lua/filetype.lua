vim.filetype.add({
    pattern = {
        -- Match any file in the specified directories
        [".*/0%.org/.*"] = "foam",
        [".*/0/.*"] = "foam",
        [".*/constant/.*"] = "foam",
        [".*/system/.*"] = "foam",

        -- Check the first 10 lines of any file for "FoamFile"
        [".*"] = {
            function(path, bufnr)
                local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)
                for _, line in ipairs(lines) do
                    if line:match("FoamFile") then
                        return "foam"
                    end
                end
            end,

            priority = -math.huge,
        },
    },
})
