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

local function ensure_dir(dir)
    if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
    end
end

---Computes the full note path and ensures its parent directory exists.
---@param filename string
---@param base_dir string|nil
---@return string
local function ensure_note_path(filename, base_dir)
    local path = get_note_path(filename, base_dir)
    ensure_dir(vim.fs.dirname(path))
    return path
end

M.validate_filename = validate_filename
M.get_note_path = get_note_path
M.ensure_dir = ensure_dir
M.ensure_note_path = ensure_note_path

M._validate_file_err = VALIDATE_FILENAME_ERR

return M
