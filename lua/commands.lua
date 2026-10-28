vim.api.nvim_create_user_command("PackAdd", function(opts)
    vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins" })

local function plugin_names()
    return vim.tbl_map(function(p) return p.spec.name end, vim.pack.get())
end

vim.api.nvim_create_user_command("PackDel", function(opts)
    vim.pack.del(opts.fargs)
end, { nargs = "+", complete = plugin_names, desc = "Delete plugins" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
    vim.pack.update(#opts.fargs > 0 and opts.fargs or nil) -- nil = update all
end, { nargs = "*", complete = plugin_names, desc = "Update all or specific plugins" })
