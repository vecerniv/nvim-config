vim.bo.shiftwidth = 2
vim.bo.tabstop = 2

vim.keymap.set("n", "<leader>bb", "<cmd>LspTexlabBuild<cr>", { buffer = true, desc = "Build LaTeX" })
vim.keymap.set("n", "<leader>bc", "<cmd>LspTexlabCleanArtifacts<cr>", { buffer = true, desc = "Clean LaTeX" })
vim.keymap.set("n", "<leader>br", "<cmd>LspTexlabCleanArtifacts<cr><cmd>LspTexlabBuild<cr>",
    { buffer = true, desc = "Rebuild LaTeX from scratch" })
