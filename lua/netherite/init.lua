local M = {}

local EXTENSION = ".md"
local group = vim.api.nvim_create_augroup("netherite_group", { clear = true })

local function validate_filename(filename)
	if not filename or filename == "" then
		return "filename cannot be empty"
	end

	return nil
end

local function get_note_path(filename, base_dir)
	base_dir = base_dir or vim.fn.stdpath("data")
	return vim.fs.joinpath(base_dir, filename .. EXTENSION)
end

local function create_buf(filename)
	local err = validate_filename(filename)

	if err then
		vim.notify(err, vim.log.levels.ERROR)
		return nil
	end

	local path = get_note_path(filename)

	local buf = vim.api.nvim_create_buf(false, false)
	vim.bo[buf].buftype = ""
	vim.bo[buf].filetype = "markdown"
	vim.api.nvim_buf_set_name(buf, path)

	return buf
end

local function create_win(buf_id)
	local opts = {}
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

	local win_id = vim.api.nvim_open_win(buf_id, true, opts)
	return win_id
end

local function load_note(buf_id, filename)
	local err = validate_filename(filename)

	if err then
		vim.notify(err, vim.log.levels.ERROR)
		return nil
	end

	local file_path = get_note_path(filename)

	if vim.fn.filereadable(file_path) == 1 then
		vim.api.nvim_buf_call(buf_id, function()
			vim.cmd("edit " .. file_path)
		end)
	end
end

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

M.toggle = function(filename)
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
