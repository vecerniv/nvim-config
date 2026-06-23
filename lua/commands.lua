vim.api.nvim_create_user_command("PackAdd", function(opts)
	vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins" })

vim.api.nvim_create_user_command("PackDel", function(opts)
	vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
	-- check if an argument is passed
	if opts.args:match("%S") then
		-- get specific plugins
		local plugins = vim.split(opts.args, "%s+", { trimempty = true })
		-- update specific plugins
		vim.pack.update(plugins)
	else
		-- update all
		vim.pack.update()
	end

end, { nargs = "*", desc = "Update all plugins or specific ones" })
