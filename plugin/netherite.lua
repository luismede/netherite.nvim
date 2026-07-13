vim.api.nvim_create_user_command("NetheriteToggle", function(opts)
    local filename = opts.args ~= "" and opts.args or nil
    require("netherite").toggle(filename)
end, { nargs = "?" })

vim.api.nvim_create_user_command("NetheriteMode", function(opts)
    require("netherite.config").mode(opts.args)
end, {
    nargs = 1,
    desc = "Set the open mode for Netherite",
    complete = function(arg_lead)
        local modes = { "split", "float" }
        return vim.tbl_filter(function(mode)
            return vim.startswith(mode, arg_lead)
        end, modes)
    end,
})

vim.api.nvim_create_user_command("NetheriteVault", function(opts)
    local vault_path = opts.args ~= "" and opts.args or nil
    require("netherite.config").change_vault(vault_path)
end, {
    nargs = "?",
    desc = "Set the vault path. If an empty argument is passed, the current path will be used",
})

vim.api.nvim_create_user_command("NetheriteHistory", function ()
	local history = require("netherite.history")
	local entries = history.load()

	if #entries == 0 then
		vim.notify("Netherite: no history yet!", vim.log.levels.INFO)
		return
	end

	vim.ui.select(entries, {
		prompt = "Netherite history",
		format_item = function (entry)
			return vim.fn.fnamemodify(entry.path, ":~:.")
		end,
	}, function (choice)
		if choice then
			require("netherite").toggle(choice.filename)
		end
	end)
end, {
	desc = "Open the history of notes"
})