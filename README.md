# `netherite.nvim`

A Neovim plugin for quick notes that sync with your Obsidian vault. Write fast, sync seamlessly.

Notes are stored as plain Markdown (`.md`) files in a configurable directory, so you can open
and sync them with Obsidian — or any editor — while staying inside Neovim.

## Requirements

- Neovim >= 0.9.0
- A directory to act as your vault (defaults to Neovim's data path)

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "luismede/netherite.nvim",
    config = function()
        require("netherite").setup({
            vault_path = "/path/to/obsidian/vault",
        })
    end,
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
    "luismede/netherite.nvim",
    config = function()
        require("netherite").setup({
            vault_path = "/path/to/obsidian/vault",
        })
    end,
})
```

### Manual

Copy the `lua/netherite/` and `plugin/` directories into your Neovim config
under `~/.config/nvim/` (or `stdpath("config")`).

## Configuration

Call `setup` with any of the options below. All are optional.

| Option             | Type    | Default                  | Description                                                       |
| ------------------ | ------- | ------------------------ | ----------------------------------------------------------------- |
| `vault_path`       | string  | `vim.fn.stdpath("data")` | Directory where notes are stored and read from.                    |
| `open_mode`        | string  | `"float"`                | How the note window opens. `"float"` (centered) or `"split"` (right). |
| `default_filename` | string  | `"scratch"`              | File used when `:Netherite` is called without args.          |

Example:

```lua
require("netherite").setup({
    vault_path = "~/notes",
    open_mode = "float",
    default_filename = "scratch",
})
```

## Commands

| Command                       | Description                                                |
| ----------------------------- | --------------------------------------------------------- |
| `:Netherite [filename]` | Open or close the note window. Opens `default_filename` when no argument is given. The `.md` extension is added automatically. |
| `:NetheriteMode {mode}`       | Change how the window opens at runtime: `"split"` or `"float"`. |
| `:NetheriteVault [path]`      | Set the vault path at runtime. Without an argument, the current working directory is used. |
| `:NetheriteHistory`           | Browse recently opened notes via `vim.ui.select` and open a selected one. |

The `.md` extension is added automatically. Re-running `:Netherite`
closes the window and discards the buffer.

## Lua API

```lua
require("netherite").setup(opts)    -- apply configuration (see table above)
require("netherite").toggle(name)   -- open or close a note by filename
```

Example keymap:

```lua
vim.keymap.set("n", "<leader>tne", function()
    require("netherite").toggle("scratch")
end, { desc = "Toggle netherite note" })
```

## Recommended plugins

### [render-markdown.nvim](https://github.com/meanderingprogrammer/render-markdown.nvim)

Since notes are plain Markdown, installing
[render-markdown.nvim](https://github.com/meanderingprogrammer/render-markdown.nvim)
improves how they render inside Neovim — headings, lists, code blocks, and
tables are highlighted and indented for easier reading.

With lazy.nvim:

```lua
{
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
}
```

## License

MIT
