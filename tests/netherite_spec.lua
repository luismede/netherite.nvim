local utils = require("netherite.utils")
local history = require("netherite.history")

describe("netherite", function()
    it("can be required", function()
        assert.not_nil(require("netherite"))
    end)
end)

describe("get_note_path", function()
    it("appends .md extension to filename", function()
        local path = utils.get_note_path("my-note", "/tmp/netherite-test")
        assert.equal("/tmp/netherite-test/my-note.md", path)
    end)

    it("uses stdpath('data') as base when base_dir is not informed", function()
        local filename = "default-note"
        local path = utils.get_note_path(filename)
        local expected = vim.fs.joinpath(vim.fn.stdpath("data"), filename .. ".md")
        assert.equal(expected, path)
    end)

    it("uses custom base_dir when it is informed", function()
        local base_dir = "/tmp/netherite-custom"
        local path = utils.get_note_path("note", base_dir)
        local expected = vim.fs.joinpath(base_dir, "note.md")
        assert.equal(expected, path)
    end)
end)

describe("validate_filename", function()
    it("should return err when filename is empty string ('')", function()
        local filename = ""
        local err = utils.validate_filename(filename)
        assert.equal(utils._validate_file_err, err)
    end)

    it("should return err when filename is nil", function()
        local filename = nil
        local err = utils.validate_filename(filename)
        assert.equal(utils._validate_file_err, err)
    end)

    it("should return nil when filename is valid", function()
        local filename = "netherite-test"
        local got = utils.validate_filename(filename)
        assert.equal(nil, got)
    end)
end)

describe("History (push)", function()
    local _stubbed_writefile
    local _stubbed_readfile

    before_each(function()
        local store = {}

        _stubbed_writefile = vim.fn.writefile
        vim.fn.writefile = function(list, fname)
            store[fname] = list
        end

        _stubbed_readfile = vim.fn.readfile
        vim.fn.readfile = function(fname)
            if store[fname] then
                return store[fname]
            end
            return {}
        end
    end)

    after_each(function()
        vim.fn.readfile = _stubbed_readfile
        vim.fn.writefile = _stubbed_writefile
    end)

    it("can be required", function()
        assert.not_nil(history)
    end)

    it("should clear duplicate paths and move the entry to the top of the list", function()
        local entry = {
            filename = "netherite_test_notes",
            path = "~/netherite/netherite_test_notes.md",
            timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        }

        history.push(entry)
        local got = history.load()
        assert.same(entry, got[1])

        history.push(entry)

        got = history.load()
        assert.equal(1, #got)
        assert.same(entry, got[1])
    end)

    it("should handle dedup with multiple unique entries", function()
        local entry1 = {
            filename = "note-a",
            path = "~/netherite/note-a.md",
            timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        }
        local entry2 = {
            filename = "note-b",
            path = "~/netherite/note-b.md",
            timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        }

        history.push(entry1)
        history.push(entry2)
        history.push(entry1)

        local got = history.load()
        assert.equal(2, #got)
        assert.same(entry1, got[1])
        assert.same(entry2, got[2])
    end)

    it("should return an empty table when history is empty or does not exist", function()
        local expected = {}

        local got = history.load()
        assert.same(expected, got)
        assert.equal(0, #got)
    end)

    it("should limit history to 50 entries", function()
        for i = 1, 51, 1 do
            local filename = "netherite_test" .. i
            history.push({
                filename = filename,
                path = "~/netherite/" .. filename,
                timestamp = os.date("%Y-%m-%d %H:%M:%S"),
            })
        end

        local got = history.load()
        assert.equal(50, #got)
    end)
end)
