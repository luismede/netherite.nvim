local M = {}

-- TODO: include timestamp in history entry
---@class NetheriteHistoryEntry
---@field filename string The name of the note file.
---@field path string The full path to the note file.
---@field timestamp string The timestamp when the note was opened.

local HISTORY_FILE = vim.fn.stdpath("data") .. "/netherite_history.json"
local MAX_ENTRIES = 50

local function save(history)
    local encoded = vim.fn.json_encode(history)
    vim.fn.writefile({encoded}, HISTORY_FILE)
end

function M.load()
    local ok, data = pcall(vim.fn.readfile, HISTORY_FILE)
    if not ok or #data == 0 then
        return {}
    end
    local decoded = vim.fn.json_decode(table.concat(data, ""))
    return type(decoded) == "table" and decoded or {}
end

---@param entry NetheriteHistoryEntry
function M.push(entry)
    local history = M.load()
    for i, e in pairs(history) do
        if e.path == entry.path then
            table.remove(history, i)
            break
        end
    end

    table.insert(history, 1, entry)
    if #history > MAX_ENTRIES then
        history[#history] = nil
    end

    save(history)
end

return M