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

---@param filename string
---@param base_dir string|nil
---@return string
local function ensure_note_path(filename, base_dir)
    local path = get_note_path(filename, base_dir)
    ensure_dir(vim.fs.dirname(path))
    return path
end

---@param filename_config NetheriteFilenameConfig
---@return string|nil Filename generated based on the provided filename configuration.
local function create_filename(filename_config)
    if not filename_config.filename then
        return nil
    end

    local filename = filename_config.filename

    local date = (not filename_config.date or #filename_config.date == 0) and "" or ("-" .. os.date(filename_config.date))
    local time = (not filename_config.time or #filename_config.time == 0) and "" or ("-" .. os.date(filename_config.time))

    return string.format("%s%s%s", filename, date, time)
end

M.validate_filename = validate_filename
M.get_note_path = get_note_path
M.ensure_dir = ensure_dir
M.ensure_note_path = ensure_note_path
M.create_filename = create_filename

M._validate_file_err = VALIDATE_FILENAME_ERR

return M
