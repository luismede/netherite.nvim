local M = {}

local EXTENSION = ".md"
local VALIDATE_FILENAME_ERR = "filename cannot be empty"

---@param filename string|nil
---@return string|nil
local function validate_filename(filename)
	if not filename or filename == "" then
		return M._validate_file_err
	end

	return nil
end

---@param filename string
---@param base_dir string|nil
---@return string
local function get_note_path(filename, base_dir)
	base_dir = base_dir or vim.fn.stdpath("data")
	return vim.fs.joinpath(base_dir, filename .. EXTENSION)
end

M.validate_filename = validate_filename
M.get_note_path = get_note_path

M._validate_file_err = VALIDATE_FILENAME_ERR

return M
