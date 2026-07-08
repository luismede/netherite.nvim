vim.api.nvim_create_user_command("NoteToggle", function()
	require("note").toggle()
end, { desc = "Open note window" })
