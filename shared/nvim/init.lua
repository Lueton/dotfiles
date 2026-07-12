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

vim.diagnostic.config({
  virtual_text = { source = true }, -- show messages inline, always prefixed with the source name
  float = { source = true }, -- same rule for the <leader>e floating window
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

vim.keymap.set({ "n", "v" }, "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- gd/gD are otherwise just Vim's built-in, text-based jump within the current
-- buffer; redirect them to real LSP navigation here.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration" })
  end,
})

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
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x", -- pinned stable release branch
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim", -- UI building blocks neo-tree renders itself with
      },
      keys = {
        { "<leader>fe", "<cmd>Neotree toggle<cr>", desc = "Toggle File Explorer" },
        { "<leader>fo", "<cmd>Neotree focus<cr>", desc = "Focus File Explorer" },
      },
      opts = {
        close_if_last_window = true, -- closing the last real file window also closes Neo-tree, instead of leaving it orphaned
        filesystem = {
          filtered_items = {
            hide_dotfiles = false, -- show dotfiles (e.g. .prettierrc) instead of counting them as "hidden"
            hide_gitignored = false, -- show git-ignored files too
          },
        },
      },
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
      "MagicDuck/grug-far.nvim",
      cmd = "GrugFar", -- only needed once you actually invoke it
      keys = {
        { "<leader>sr", "<cmd>GrugFar<cr>", desc = "Search and Replace (project-wide)" },
      },
      opts = {
        keymaps = {
          -- default is <localleader>c, i.e. plain "\c" since we never set maplocalleader;
          -- "q" matches the usual close convention for this kind of result window
          close = { n = "q" },
        },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main", -- the old "master" API (ensure_installed in setup{}) is retired; "main" is now the only supported branch
      build = ":TSUpdate", -- keeps installed parsers up to date whenever the plugin itself updates
      config = function()
        -- Explicit list of languages we want parsers for (no auto_install).
        -- Parser names don't always match filetype names (e.g. the "tsx"
        -- parser also covers the "typescriptreact" filetype), so filetypes
        -- to activate highlighting for are listed separately below.
        local parsers = { "javascript", "typescript", "tsx", "java", "python", "yaml", "xml" }

        require("nvim-treesitter").install(parsers)

        -- Highlighting is provided by Neovim core, but must be turned on per filetype
        local highlight_filetypes = {
          "javascript", "javascriptreact",
          "typescript", "typescriptreact",
          "java", "python", "yaml", "xml",
        }
        vim.api.nvim_create_autocmd("FileType", {
          pattern = highlight_filetypes,
          callback = function()
            vim.treesitter.start()
          end,
        })
      end,
    },
    {
      "mfussenegger/nvim-dap",
      keys = {
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end, desc = "Continue / Start Debugging" },
        { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
        { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
        { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      },
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
      keys = {
        { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle Debug UI" },
      },
      config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup()
        -- auto-open/close the debug UI windows around a debug session
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end
      end,
    },
    {
      -- registers Python debug configurations (via debugpy) into the already
      -- generic nvim-dap/nvim-dap-ui setup above, the same way jdtls wires
      -- itself into nvim-dap for Java
      "mfussenegger/nvim-dap-python",
      ft = "python",
      dependencies = { "mfussenegger/nvim-dap" },
      config = function()
        -- Mason installs debugpy into its own isolated venv, not system Python
        local mason_registry = require("mason-registry")
        local debugpy_path = mason_registry.get_package("debugpy"):get_install_path() .. "/venv/bin/python"
        require("dap-python").setup(debugpy_path)
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {},
    },
    {
      -- Shows LSP progress ("Indexing...") and window/showMessage notifications
      -- (e.g. spring-boot's "MCP server started" notice) as an auto-fading popup
      -- instead of a permanent line in the command area. override_vim_notify
      -- redirects vim.notify() itself, which is what window/showMessage uses.
      "j-hui/fidget.nvim",
      event = "LspAttach",
      opts = {
        notification = {
          override_vim_notify = true,
          window = {
            winblend = 0, -- fidget defaults to 100 (fully transparent), which draws no
                          -- background at all and lets the popup text collide with the
                          -- buffer behind it; 0 makes the popup fully opaque instead.
          },
        },
      },
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        -- "ts_ls" is nvim-lspconfig's name for typescript-language-server (handles JS and TS)
        ensure_installed = { "ts_ls", "basedpyright" },
        -- jdtls gets its own dedicated setup below (via nvim-jdtls) with custom
        -- JDK runtimes, debug bundles, and Spring Boot support. Without this
        -- exclude, mason-lspconfig's automatic_enable would also auto-start
        -- nvim-lspconfig's generic jdtls config, and the two would race to
        -- attach to the same Java buffer with different workspace caches.
        --
        -- ruff is also excluded: mason-lspconfig auto-enables it as its own LSP
        -- server (it recognizes the "ruff" mason package as LSP-capable) just
        -- because it's installed, even though it's only meant to run as a plain
        -- CLI tool here (via nvim-lint/conform below). Left enabled, its LSP
        -- diagnostics duplicate nvim-lint's ruff diagnostics on every buffer.
        automatic_enable = { exclude = { "jdtls", "ruff" } },
      },
      dependencies = {
        { "mason-org/mason.nvim", opts = {} }, -- the underlying installer/package manager
        "neovim/nvim-lspconfig", -- provides the server connection configs mason-lspconfig enables
      },
    },
    {
      -- Java's language server (jdtls) can't be driven through plain mason-lspconfig
      -- like ts_ls above: it needs a per-project workspace dir (its own index cache)
      -- and extra "bundle" jars for debugging/Spring Boot features, so it gets its
      -- own dedicated plugin and a manual start_or_attach() call instead.
      "mfussenegger/nvim-jdtls",
      ft = "java", -- only load this plugin when a Java file is opened
      config = function()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "java",
          callback = function()
            -- Walk up from the current file to find the project root (Maven/Gradle/git marker)
            local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
            if not root_dir then
              return
            end

            -- jdtls caches per-project index state in a workspace dir; give each
            -- project its own folder so they don't clash with one another
            local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
            local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

            -- Collect extra jars Mason installed for debugging (java-debug-adapter,
            -- java-test). jdtls loads these into its own JVM as "bundles" to gain
            -- those features.
            local mason_registry = require("mason-registry")
            local bundles = {}
            vim.list_extend(bundles, vim.split(vim.fn.glob(
              mason_registry.get_package("java-debug-adapter"):get_install_path()
                .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"
            ), "\n"))
            vim.list_extend(bundles, vim.split(vim.fn.glob(
              mason_registry.get_package("java-test"):get_install_path() .. "/extension/server/*.jar"
            ), "\n"))
            -- Spring Boot's own jdtls extension jars (bean navigation, endpoint
            -- discovery, etc.) come from the spring-boot.nvim plugin below, which
            -- already knows Mason's install path for vscode-spring-boot-tools
            vim.list_extend(bundles, require("spring_boot").java_extensions())

            require("jdtls").start_or_attach({
              -- "jdtls" is the wrapper script Mason installed onto $PATH
              cmd = { "jdtls", "-data", workspace_dir },
              root_dir = root_dir,
              init_options = {
                bundles = bundles,
                settings = {
                  java = {
                    -- Only used for "invisible" projects, i.e. plain folders without a
                    -- pom.xml/build.gradle (real Maven/Gradle projects ignore this and
                    -- use their own build file instead). Without it, jdtls tries to
                    -- auto-detect the source root, which is unreliable with few files:
                    -- it can register e.g. "src/app" instead of "src" as the source
                    -- folder, causing false "declared package does not match expected
                    -- package" errors.
                    project = {
                      sourcePaths = { "src" },
                      outputPath = "bin",
                    },
                    configuration = {
                      -- Tells jdtls about every JDK installed via SDKMAN so it can pick
                      -- the one that actually matches each project's <java.version>/
                      -- sourceCompatibility, instead of only ever using the JDK jdtls
                      -- itself happens to be running on (which must be 21+ regardless
                      -- of what any given project targets).
                      runtimes = {
                        { name = "JavaSE-17", path = vim.fn.expand("~/.sdkman/candidates/java/17.0.12-tem") },
                        { name = "JavaSE-21", path = vim.fn.expand("~/.sdkman/candidates/java/21.0.4-tem"), default = true },
                      },
                    },
                  },
                },
              },
            })

            -- Wires jdtls into nvim-dap so breakpoints/step-through work in Java
            require("jdtls").setup_dap({ hotcodereplace = "auto" })
          end,
        })

        -- Auto-organize imports (add missing, drop unused, sort) before every
        -- save. jdtls applies this as an async LSP edit rather than a
        -- synchronous one, so very occasionally it lands a save late instead
        -- of in the one that triggered it (see nvim-jdtls#235).
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = "*.java",
          callback = function()
            require("jdtls").organize_imports()
          end,
        })
      end,
    },
    {
      -- Runs the actual Spring Boot Language Server (a separate Java process from
      -- jdtls) to get application.properties/yml completion, bean navigation, and
      -- endpoint discovery. Talks to jdtls over custom LSP commands to share
      -- classpath info, which is why it depends on nvim-jdtls above.
      "JavaHello/spring-boot.nvim",
      ft = { "java", "yaml", "jproperties" },
      dependencies = { "mfussenegger/nvim-jdtls" },
      opts = {},
    },
    {
      -- installs non-LSP tools (formatters, linters) through Mason, the same way
      -- mason-lspconfig does it for LSP servers above
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      dependencies = { "mason-org/mason.nvim" },
      opts = {
        ensure_installed = {
          "prettier",
          "eslint_d",
          "jdtls",
          "java-debug-adapter",
          "java-test",
          "vscode-spring-boot-tools",
          "google-java-format",
          "ruff",
          "debugpy",
        },
      },
    },
    {
      "mfussenegger/nvim-lint",
      event = { "BufReadPost", "BufWritePost", "InsertLeave" }, -- (re-)lint on open, after save, and after leaving insert mode
      config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
          javascript = { "eslint_d" },
          javascriptreact = { "eslint_d" },
          typescript = { "eslint_d" },
          typescriptreact = { "eslint_d" },
          python = { "ruff" },
        }
        vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
          callback = function()
            lint.try_lint()
          end,
        })

        -- the event above that triggered this plugin to load has already passed by
        -- the time this autocmd gets registered, so lint once immediately here too;
        -- deferred a tick because filetype detection may not be finished yet at this point
        vim.schedule(function()
          lint.try_lint()
        end)
      end,
    },
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" }, -- load just in time to format before a save completes
      cmd = { "ConformInfo" },
      opts = {
        formatters_by_ft = {
          -- run in order: eslint_d fixes safely-fixable lint issues first,
          -- then prettier has the final say on whitespace/style
          javascript = { "eslint_d", "prettier" },
          javascriptreact = { "eslint_d", "prettier" },
          typescript = { "eslint_d", "prettier" },
          typescriptreact = { "eslint_d", "prettier" },
          -- takes over from jdtls's built-in (Eclipse-style) formatter so
          -- Java formatting is reproducible outside Neovim too (CI, IntelliJ)
          java = { "google-java-format" },
          python = { "ruff_format" },
        },
        format_on_save = {
          timeout_ms = 2000, -- eslint_d + prettier run sequentially now, so give the pair more headroom
          lsp_format = "fallback", -- if no formatter matched above, fall back to the LSP server's own formatting
        },
      },
    },
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy", -- only cosmetic, no need to block startup on it
      dependencies = { "nvim-tree/nvim-web-devicons" }, -- file-type icons in the statusline
      opts = {
        options = {
          theme = "catppuccin-mocha", -- matches the "mocha" flavour set above; plain "catppuccin" isn't a valid theme name
        },
      },
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter", -- only needed once you start typing, no reason to load it at startup
      opts = {},
    },
    {
      "saghen/blink.cmp",
      version = "1.*", -- pin to the stable release line; v2 is still under active, breaking development
      dependencies = { "rafamadriz/friendly-snippets" }, -- ready-made snippets for the "snippets" source
      opts = {
        keymap = { preset = "super-tab" }, -- Tab accepts/navigates down, S-Tab navigates up, C-space opens/shows docs
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
      },
    },
  },
})
