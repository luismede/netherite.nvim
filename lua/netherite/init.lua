local M = {}

-- TODO: check if using this function is the better solution
local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	if M._win_id and vim.api.nvim_win_is_valid(M._win_id) then
		vim.api.nvim_win_close(M._win_id, true)
		M._win_id = nil
	else
		if not M._buf_id or not vim.api.nvim_buf_is_valid(M._buf_id) then
			M._buf_id = vim.api.nvim_create_buf(false, true)
			vim.bo[M._buf_id].filetype = "markdown"
			vim.bo[M._buf_id].buftype = "nofile"
		end

		opts = {
			relative = "editor",
			width = width,
			height = height,
			col = col,
			row = row,
			border = "rounded",
		}

		M._win_id = vim.api.nvim_open_win(M._buf_id, true, opts)
	end
end

M._win_id = nil
M._buf_id = nil

M.toggle = function()
	create_floating_window()
end

return M
