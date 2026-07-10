local M = {}

---@class NetheriteConfig
---@field vault_path string Path to the directory where notes are stored.
---@field open_mode "float" | "split" Mode to open the note window. Can be "float" or "split".
---@field default_filename string Default filename to use when creating a new note.

---@type NetheriteConfig
local default_config = {
	vault_path = vim.fn.stdpath("data"),
	open_mode = "float",
	default_filename = "scratch",
}

M.config = default_config

---@param opts NetheriteConfig
function M.setup(opts)
	opts = opts or {}

	M.config = vim.tbl_deep_extend("force", default_config, opts)
end

---@param open_mode "float" | "split"
function M.mode(open_mode)
	local valid = {split = true, float = true}
	if not valid[open_mode] then
		vim.notify("Invalid mode. Valid modes are: split, float", vim.log.levels.ERROR)
		return
	end
	M.config.open_mode = open_mode
end

return M
