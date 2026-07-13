local utils = require("netherite.utils")
local configs = require("netherite.config")

local M = {}

local group = vim.api.nvim_create_augroup("netherite_group", { clear = true })

---@param filename string Filename of the note to open.
local function create_buf(filename)
    local err = utils.validate_filename(filename)

    if err then
        vim.notify(err, vim.log.levels.ERROR)
        return nil
    end

    local path = utils.ensure_note_path(filename, configs.config.vault_path)

    local buf = vim.api.nvim_create_buf(false, false)
    vim.bo[buf].buftype = ""
    vim.bo[buf].filetype = "markdown"
    vim.api.nvim_buf_set_name(buf, path)

    return buf
end

---@param buf_id number Buffer ID of the note to open.
---@returns number Window ID of the note window.
local function create_win(buf_id)
    local opts = {}

    if configs.config.open_mode == "split" then
        opts = {
            split = "right",
            win = 0,
        }
    else
        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor(vim.o.lines * 0.8)

        local col = math.floor((vim.o.columns - width) / 2)
        local row = math.floor((vim.o.lines - height) / 2)

        opts = {
            relative = "editor",
            width = width,
            height = height,
            col = col,
            row = row,
            border = "rounded",
        }
    end

    local win_id = vim.api.nvim_open_win(buf_id, true, opts)
    return win_id
end

---@param buf_id number Buffer ID of the note to open.
---@param filename string Filename of the note to open.
local function load_note(buf_id, filename)
    local file_path = utils.get_note_path(filename, configs.config.vault_path)

    if vim.fn.filereadable(file_path) == 1 then
        vim.api.nvim_buf_call(buf_id, function()
            vim.cmd("edit " .. file_path)
        end)
    end
end

---@param buf_id number Buffer ID of the note to open.
local function delete_buf(buf_id)
    if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then
        return
    end

    vim.api.nvim_buf_delete(buf_id, { force = true })

    M._buf_id = nil
    M._win_id = nil
end

M._win_id = nil
M._buf_id = nil
M.config = {}

M._create_buf = create_buf

M.setup = configs.setup

--TODO: set on setup to accept user to choose format
local filename_date = os.date("%Y-%m-%d")

---@param filename string|nil
---@returns number Window ID of the note window.
function M.toggle(filename)
    local default_filename = configs.config.default_filename .. filename_date
    filename = filename or default_filename

    if M._win_id and vim.api.nvim_win_is_valid(M._win_id) then
        vim.api.nvim_win_close(M._win_id, true)
        delete_buf(M._buf_id)
    else
        if not M._buf_id or not vim.api.nvim_buf_is_valid(M._buf_id) then
            M._buf_id = create_buf(filename)
        end

        load_note(M._buf_id, filename)
        M._win_id = create_win(M._buf_id)

        vim.api.nvim_create_autocmd("WinClosed", {
            group = group,
            pattern = tostring(M._win_id),
            callback = function()
                delete_buf(M._buf_id)
            end,
        })
    end
end

return M
