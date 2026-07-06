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
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {},
    },
  },
})
