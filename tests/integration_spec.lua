local netherite = require("netherite")
local utils = require("netherite.utils")

local function cleanup_buf(buf_id)
    if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
        pcall(vim.api.nvim_buf_delete, buf_id, { force = true })
    end
end

describe("toggle/create_buf (integration)", function()
    local stubbed_notify
    local notify_calls

    before_each(function()
        notify_calls = {}
        stubbed_notify = vim.notify
        vim.notify = function(msg, level)
            table.insert(notify_calls, { msg = msg, level = level })
        end

        if netherite._buf_id then
            cleanup_buf(netherite._buf_id)
        end

        if netherite._win_id and vim.api.nvim_win_is_valid(netherite._win_id) then
            pcall(vim.api.nvim_win_close, netherite._win_id, true)
        end

        netherite._buf_id = nil
        netherite._win_id = nil
    end)

    after_each(function()
        vim.notify = stubbed_notify
        if netherite._buf_id then
            cleanup_buf(netherite._buf_id)
        end
    end)

    it("creates a buffer with filetype markdown", function()
        local buf_id = netherite._create_buf("integration-note")
        assert.truthy(buf_id)
        assert.is_number(buf_id)
        assert.equal("markdown", vim.bo[buf_id].filetype)

        cleanup_buf(buf_id)
    end)

    it("sets buffer name to get_note_path path", function()
        local filename = "integration-note"
        local buf_id = netherite._create_buf(filename)
        local expected_path = utils.get_note_path(filename)

        assert.equal(expected_path, vim.api.nvim_buf_get_name(buf_id))

        cleanup_buf(buf_id)
    end)

    it("returns nil and notifies err when filename is empty", function()
        local buf_id = netherite._create_buf("")

        assert.is_nil(buf_id)
        assert.equal(1, #notify_calls)
        assert.equal(utils._validate_file_err, notify_calls[1].msg)
        assert.equal(vim.log.levels.ERROR, notify_calls[1].level)
    end)

    it("returns nil and notifies err when filename is nil", function()
        local buf_id = netherite._create_buf(nil)

        assert.is_nil(buf_id)
        assert.equal(1, #notify_calls)
        assert.equal(utils._validate_file_err, notify_calls[1].msg)
        assert.equal(vim.log.levels.ERROR, notify_calls[1].level)
    end)
end)

describe("toggle (integration)", function()
    before_each(function()
        if netherite._win_id and vim.api.nvim_win_is_valid(netherite._win_id) then
            pcall(vim.api.nvim_win_close, netherite._win_id, true)
        end
        if netherite._buf_id then
            cleanup_buf(netherite._buf_id)
        end
        netherite._buf_id = nil
        netherite._win_id = nil
    end)

    after_each(function()
        if netherite._win_id and vim.api.nvim_win_is_valid(netherite._win_id) then
            pcall(vim.api.nvim_win_close, netherite._win_id, true)
        end
        if netherite._buf_id then
            cleanup_buf(netherite._buf_id)
        end
        netherite._buf_id = nil
        netherite._win_id = nil
    end)

    it("opens a valid window and buffer on the first call", function()
        netherite.toggle("toggle-note")

        assert.truthy(netherite._win_id)
        assert.truthy(netherite._buf_id)
        assert.is_true(vim.api.nvim_win_is_valid(netherite._win_id))
        assert.is_true(vim.api.nvim_buf_is_valid(netherite._buf_id))
        assert.equal("markdown", vim.bo[netherite._buf_id].filetype)
        assert.equal(
            utils.get_note_path("toggle-note"),
            vim.api.nvim_buf_get_name(netherite._buf_id)
        )
    end)

    it("closes the window on the second call", function()
        netherite.toggle("toggle-note")
        local win_id = netherite._win_id
        assert.is_true(vim.api.nvim_win_is_valid(win_id))

        netherite.toggle("toggle-note")

        assert.is_nil(netherite._win_id)
        assert.is_false(vim.api.nvim_win_is_valid(win_id))
    end)

    it("deletes the buffer when the window is closed", function()
        netherite.toggle("toggle-note")
        local buf_id = netherite._buf_id
        assert.is_true(vim.api.nvim_buf_is_valid(buf_id))

        netherite.toggle("toggle-note")

        assert.is_nil(netherite._buf_id)
        assert.is_false(vim.api.nvim_buf_is_valid(buf_id))
    end)

    it("opens a different buffer when called with a different filename", function()
        netherite.toggle("note-alpha")
        local first_buf = netherite._buf_id
        local first_name = vim.api.nvim_buf_get_name(first_buf)
        netherite.toggle("note-alpha")

        netherite.toggle("note-beta")
        local second_buf = netherite._buf_id
        local second_name = vim.api.nvim_buf_get_name(second_buf)

        assert.is_true(vim.api.nvim_buf_is_valid(second_buf))
        assert.is_true(vim.api.nvim_win_is_valid(netherite._win_id))
        assert.not_equal(first_name, second_name)
        assert.equal(utils.get_note_path("note-beta"), second_name)
        assert.is_false(vim.api.nvim_buf_is_valid(first_buf))
    end)
end)
