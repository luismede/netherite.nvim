vim.api.nvim_create_user_command("NetheriteToggle", function()
	require("plugin.netherite").toggle()
end, { desc = "Open note window" })
