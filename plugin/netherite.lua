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

--TODO: create command to list recent notes
