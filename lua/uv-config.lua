-- Lazy load uv.nvim when a Python file is opened
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	once = true,
	callback = function()
		local ok, uv = pcall(require, 'uv')
		if ok then
			uv.setup({
				-- Auto-activate virtual environments when found
				auto_activate_venv = true,
				notify_activate_venv = false,  -- Disable notification spam

				-- Auto commands for directory changes
				auto_commands = true,

				-- Execution options
				execution = {
					run_command = "uv run python",
					notify_output = false,  -- Disable notification spam
					notification_timeout = 10000,
				},
			})
		end
	end,
})
