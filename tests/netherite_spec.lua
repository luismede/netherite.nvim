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
        assert.equal(base_dir .. "/note.md", path)
        assert.truthy(string.find(path, "^" .. vim.pesc(base_dir)))
    end)
end)

describe("validate_filename", function()
    it("should return err when filename is empty string ('') )", function()
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

describe("History (push)", function ()
	local _stubbed_writefile
	local _stubbed_readfile

	local timestamp = os.date("%Y-%m-%d %H:%M:%S")

	before_each(function ()
		local mock_write_calls = {}
		_stubbed_writefile = vim.fn.writefile
		vim.fn.writefile = function (list, fname)
			table.insert(mock_write_calls, {
				list = list,
				fname = fname,
			})
		end

		_stubbed_readfile = vim.fn.readfile
		vim.fn.readfile = function (fname)
			if fname == "netherite_history.json" then
				if not mock_write_calls or #mock_write_calls == 0 then
					return {}
				end
				return mock_write_calls[#mock_write_calls].list
			end

			return {}
		end
	end)

	after_each(function ()
		vim.fn.readfile = _stubbed_readfile
		vim.fn.writefile = _stubbed_writefile
	end)

	it("can be required", function()
		assert.not_nil(history)
	end)

	it("debug json_decode", function()
    local encoded = vim.fn.json_encode({ filename = "test", path = "~/test.md" })
    print("encoded: " .. encoded)
    local decoded = vim.fn.json_decode(encoded)
    print("decoded type: " .. type(decoded))
end)

	it("shoud clear duplications history and return file on top of the list", function ()
		local expected = {
			filename = "netherite_test_notes",
			path = "~/netherite/netherite_test_notes.md",
			timestamp = timestamp
		}

		history.push(expected)
		local got = history.load()
		assert.equal(expected.path, got[1].path)

		history.push(expected)
		
		got = history.load()
		assert.equal(1, #got)
		assert.equal(expected, got[1])
	end)

	it("shoud return an empty table when history is empty or not exists", function ()
		local expected = {}

		local got = history.load()
		assert.equal(expected, got)		
		assert.equal(0, #got)
	end)

	it("should limit history to 50 entries", function ()
		for i = 1, 51, 1 do
			local filename = "netherite_test" .. i
			history.push({
				filename = filename,
				path = "~/netherite/" .. filename,
				timestamp = tostring(timestamp)
			})
		end

		local got = history.load()
		assert.equal(50, #got)		
	end)
end)
