# Contributing to netherite.nvim

Thanks for your interest in contributing! This document explains how to set up
the project and the conventions to follow.

> Repository: <https://github.com/luismede/netherite.nvim>

## Prerequisites

- Neovim >= 0.9.0
- Lua >= 5.1 (or LuaJIT, as shipped with Neovim)
- [`stylua`](https://github.com/JohnnyMorganz/StyLua) for formatting
- [`luacheck`](https://github.com/mpeterv/luacheck) for linting (optional but recommended)

## Getting started

1. Fork and clone the repository:

   ```sh
   git clone https://github.com/luismede/netherite.nvim.git
   cd netherite.nvim
   ```

2. Start Neovim with the repo on the runtimepath so the plugin loads from
   your working copy:

   ```sh
   nvim --cmd "set rtp+=$(pwd)"
   ```

3. Make your changes in `lua/netherite/` (source) or `plugin/netherite.lua`
   (user commands).

## Code style

This project uses [StyLua](https://github.com/JohnnyMorganz/StyLua) for
formatting. Before submitting, run:

```sh
stylua lua/ plugin/ tests/
# or
make format
```

Conventions to follow:

- Use tabs for indentation (StyLua enforces this).
- Keep line length under 100 columns where possible.
- Prefixed `M._private` for internal fields meant only for testing.
- Prefer early returns; keep functions small and focused.
- Do **not** add comments unless the code is non-obvious. Existing doc
  comments (`---`) on public helpers should be preserved.

## Tests

Tests live in `tests/`. Run them with:

```sh
make test
```

If you add a new public function, add a corresponding test case.

## Commit messages

Follow the conventional commits style:

- `feat:`     new feature
- `fix:`      bug fix
- `docs:`     documentation changes (README, `vimdoc`)
- `refactor:` code reorganization without behavior change
- `test:`     test additions or fixes
- `chore:`    tooling, CI, dependencies

Example:

```
feat: add :NetheriteRecent command to list latest notes
```

Thanks for keeping this style consistent.

## Pull requests

Before opening a pull request:

1. Format with `stylua`.
2. Make sure tests pass locally.
3. Update `doc/netherite.txt` if you add or change a user-facing command
   or option.
4. Rebase onto the latest `main` to avoid merge commits when possible.

Open your PR against the `main` branch with a clear description of what and
why. For bigger changes, consider opening an issue first to discuss the
approach.

## Reporting issues

If you hit a bug, open an issue at
<https://github.com/luismede/netherite.nvim/issues> and include:

- Neovim version (`nvim -v` or `:version`)
- Your `setup()` configuration
- Minimal steps to reproduce
- Expected vs. actual behavior

## Code of conduct

Be respectful. Personal attacks, harassment, or discrimination are not
tolerated. Unacceptable behaviour may result in being barred from
contributing.

## License

By contributing, you agree that your contributions will be licensed under
the MIT License.

Thanks for helping make `netherite.nvim` better!
