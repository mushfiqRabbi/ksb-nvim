vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
	group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
	callback = function()
		io.stdout:write("\x1b]1337;SetUserVar=in_ksb=MQo\007")
	end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
	group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
	callback = function()
		io.stdout:write("\x1b]1337;SetUserVar=in_ksb\007")
	end,
})

-- Set space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use system clipboard unless in an SSH session.
-- When running locally, set clipboard to 'unnamedplus' to enable integration with the OS clipboard.
-- When connected via SSH (where system clipboard access is usually unavailable), disable clipboard sync to avoid errors.
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	spec = {
		{
			"mikesmithgh/kitty-scrollback.nvim",
			enabled = true,
			lazy = true,
			cmd = {
				"KittyScrollbackGenerateKittens",
				"KittyScrollbackCheckHealth",
				"KittyScrollbackGenerateCommandLineEditing",
			},
			event = { "User KittyScrollbackLaunch" },
			config = function()
				require("kitty-scrollback").setup({
					{
						status_window = {
							style_simple = true,
							show_timer = true,
						},
						paste_window = {
							yank_register_enabled = false,
						},

						highlight_overrides = {
							KittyScrollbackNvimStatusWinNormal = {
								bg = "#ff757f",
								fg = "#1b1d2b",
								bold = true,
							},
							KittyScrollbackNvimStatusWinSpinnerIcon = {
								link = "KittyScrollbackNvimStatusWinNormal",
							},
							KittyScrollbackNvimStatusWinReadyIcon = {
								link = "KittyScrollbackNvimStatusWinNormal",
							},
							KittyScrollbackNvimVisual = {
								link = "KittyScrollbackNvimStatusWinNormal",
							},
						},
					},
				})
			end,
		},
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
	},
	-- install = { colorscheme = { "tokyonight", "habamax" } },
	-- ui = {
	--   border = "single",
	-- },
	checker = { enabled = true }, -- automatically check for plugin updates
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
}, {
	rocks = {
		hererocks = true,
	},
})
