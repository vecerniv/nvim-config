local function foam_if_no_ext(path)
	if not vim.fs.basename(path):find("%.") then return "foam" end
end

vim.filetype.add({
	pattern = {
		[".*/0%.orig/.*"] = foam_if_no_ext,
		[".*/0/.*"] = foam_if_no_ext,
		[".*/constant/.*"] = foam_if_no_ext,
		[".*/system/.*"] = foam_if_no_ext,
		[".*"] = {
			function(_, bufnr)
				for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)) do
					if line:match("FoamFile") then return "foam" end
				end
			end,
			{ priority = -math.huge }, -- negative priority: checked after extensions
		},
	},
})

