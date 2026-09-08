local foam_group = vim.api.nvim_create_augroup("FOAMFTautocmds", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = foam_group,
	pattern = "*",
	callback = function(args)
		-- Read first 10 lines to find FoamFile
		local lines = vim.api.nvim_buf_get_lines(args.buf, 0, 10, false)

		for _, line in ipairs(lines) do
			if line:match("FoamFile") then
				vim.bo[args.buf].filetype = "foam"
				break
			end
		end
	end,
})
