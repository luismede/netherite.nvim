vim.api.nvim_create_user_command("NetheriteToggle", function(opts)
	local filename = opts.args ~= "" and opts.args or nil
	require("netherite").toggle(filename)
end, { nargs = "?" })

--TODO: accept only {"split" and "float"}
vim.api.nvim_create_user_command("NetheriteMode", function(opts)
	require("netherite.config").config.open_mode = opts.args
end, { nargs = 1 })

--TODO: create command to list recent notes
