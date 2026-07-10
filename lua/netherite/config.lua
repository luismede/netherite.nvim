local M = {}

local default_config = {
	vault_path = vim.fn.stdpath("data"),
	open_mode = "float",
	default_filename = "scratch",
}

M.config = default_config

M.setup = function(opts)
	opts = opts or {}

	M.config = vim.tbl_deep_extend("force", default_config, opts)
end

return M
