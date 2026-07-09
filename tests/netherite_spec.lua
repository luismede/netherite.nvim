local utils = require("netherite.utils")

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
