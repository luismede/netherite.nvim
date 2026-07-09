vim.api.nvim_create_user_command("NetheriteToggle", function(opts)
	require("netherite").toggle(opts.args)
end, { nargs = 1 })
