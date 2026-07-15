local M = {}

---@class NetheriteConfig
---@field vault_path string Path to the directory where notes are stored.
---@field open_mode "float" | "split" Mode to open the note window. Can be "float" or "split".
---@field filename_config NetheriteFilenameConfig Configuration for the default filename.

---@class NetheriteFilenameConfig
---@field filename string Default filename to use when creating a new note.
---@field date string Date format to append to the default filename. Can be "YYYY-MM-DD", "MM-DD-YYYY", etc.
---@field time string Time format to append to the default filename. Can be "HH:MM", "HH:MM:SS", etc.

---@type NetheriteFilenameConfig
local filename_config = {
    filename = "Untitled",
    date = "%Y-%m-%d",
    time = "%H:%M:%S",
}

---@type NetheriteConfig
local default_config = {
    vault_path = vim.fn.stdpath("data"),
    open_mode = "float",
    filename_config = filename_config,
}

local function normalize_filename_config(opts)
    local config =
        vim.tbl_deep_extend("force", default_config.filename_config, opts.filename_config or {})

    if opts.default_filename ~= nil then
        vim.notify(
            "Netherite: default_filename is deprecated; use filename_config.filename instead",
            vim.log.levels.WARN
        )

        if opts.filename_config == nil or opts.filename_config.filename == nil then
            config.filename = opts.default_filename
        end
    end

    return config
end

M.config = default_config

---@param opts NetheriteConfig
function M.setup(opts)
    opts = opts or {}

    M.config = vim.tbl_deep_extend("force", default_config, opts)
    M.config.filename_config = normalize_filename_config(opts)
    M.config.vault_path = vim.fn.expand(M.config.vault_path)
end

---@param open_mode "float" | "split"
function M.mode(open_mode)
    local valid = { split = true, float = true }
    if not valid[open_mode] then
        vim.notify("Invalid mode. Valid modes are: split, float", vim.log.levels.ERROR)
        return
    end
    M.config.open_mode = open_mode
end

function M.change_vault(vault_path)
    if not vault_path then
        local cwd = vim.fn.getcwd()
        M.config.vault_path = cwd
    else
        M.config.vault_path = vim.fn.expand(vault_path)
    end
end

return M
