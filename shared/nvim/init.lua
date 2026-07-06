vim.g.mapleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true -- case-sensitive search only if query contains uppercase

opt.mouse = "a"
opt.clipboard = "unnamedplus" -- yank/paste through the system clipboard
opt.scrolloff = 8 -- keep 8 lines visible above/below the cursor
opt.signcolumn = "yes" -- reserve space for signs so text doesn't shift
opt.splitright = true
opt.splitbelow = true
opt.undofile = true -- persist undo history across sessions
opt.termguicolors = true -- required for accurate colorschemes/plugin themes

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000, -- load before other plugins so colors are ready when they render
      opts = {
        flavour = "mocha", -- dark variant; other options: latte, frappe, macchiato
      },
      config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
      end,
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {},
    },
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x", -- pinned stable release branch, not the unstable main branch
      dependencies = { "nvim-lua/plenary.nvim" }, -- utility library telescope is built on
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      },
      opts = {
        defaults = {
          preview = {
            -- telescope's previewer still calls nvim-treesitter's old ft_to_lang() API,
            -- which no longer exists on nvim-treesitter's "main" branch; fall back to
            -- plain regex-based syntax highlighting in the preview pane instead
            treesitter = false,
          },
        },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main", -- the old "master" API (ensure_installed in setup{}) is retired; "main" is now the only supported branch
      build = ":TSUpdate", -- keeps installed parsers up to date whenever the plugin itself updates
      config = function()
        -- Explicit list of languages we want parsers for (no auto_install)
        local parsers = { "javascript" }

        require("nvim-treesitter").install(parsers)

        -- Highlighting is provided by Neovim core, but must be turned on per filetype
        vim.api.nvim_create_autocmd("FileType", {
          pattern = parsers,
          callback = function()
            vim.treesitter.start()
          end,
        })
      end,
    },
  },
})
