-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Visual settings
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.wrap = false
opt.cursorline = true
opt.colorcolumn = "80"

-- File handling
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true

-- Split behavior
opt.splitright = true
opt.splitbelow = true

-- Scroll behavior
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Command line
opt.cmdheight = 1
opt.showmode = false

-- Performance
opt.updatetime = 250
opt.timeoutlen = 500

-- Clipboard (system clipboard integration)
opt.clipboard = "unnamedplus"

-- Mouse support
opt.mouse = "a"

-- Install lazy.nvim plugin manager
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

-- Plugin specifications
local plugins = {
  -- Dracula theme
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    config = function()
      local dracula = require("dracula")
      dracula.setup({
        colors = {
          bg = "#282A36",
          fg = "#F8F8F2",
          selection = "#44475A",
          comment = "#6272A4",
          red = "#FF5555",
          orange = "#FFB86C",
          yellow = "#F1FA8C",
          green = "#50fa7b",
          purple = "#BD93F9",
          cyan = "#8BE9FD",
          pink = "#FF79C6",
        },
        show_end_of_buffer = true,
        transparent_bg = false,
        lualine_bg_color = "#44475a",
        italic_comment = true,
      })
      vim.cmd.colorscheme("dracula")
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "dracula",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {"mode"},
          lualine_b = {"branch", "diff", "diagnostics"},
          lualine_c = {"filename"},
          lualine_x = {"encoding", "fileformat", "filetype"},
          lualine_y = {"progress"},
          lualine_z = {"location"}
        },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
      })
      
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = function()
      -- Check if we have a C compiler before trying to build
      local has_compiler = vim.fn.executable("cc") == 1 or 
                          vim.fn.executable("gcc") == 1 or 
                          vim.fn.executable("clang") == 1
      if has_compiler then
        return ":TSUpdate"
      else
        vim.notify("No C compiler found. Treesitter parsers will need to be installed manually.", vim.log.levels.WARN)
        return ""
      end
    end,
    config = function()
      -- Check if we have a C compiler
      local has_compiler = vim.fn.executable("cc") == 1 or 
                          vim.fn.executable("gcc") == 1 or 
                          vim.fn.executable("clang") == 1
      
      local parsers_to_install = {}
      if has_compiler then
        parsers_to_install = {
          "c", "cpp", "lua", "tsx", "typescript",
          "vimdoc", "vim", "bash", "javascript", "html", "css", "json",
          "yaml", "markdown", "dockerfile", "java"
        }
      end
      
      require("nvim-treesitter.configs").setup({
        ensure_installed = parsers_to_install,
        auto_install = false,
        highlight = { 
          enable = true,
          -- Fallback to vim syntax if treesitter fails
          additional_vim_regex_highlighting = true,
        },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          
          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, {expr=true})
          
          map("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, {expr=true})
          
          -- Actions
          map({"n", "v"}, "<leader>hs", ":Gitsigns stage_hunk<CR>")
          map({"n", "v"}, "<leader>hr", ":Gitsigns reset_hunk<CR>")
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hu", gs.undo_stage_hunk)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function() gs.blame_line{full=true} end)
          map("n", "<leader>tb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function() gs.diffthis("~") end)
          map("n", "<leader>td", gs.toggle_deleted)
        end
      })
    end,
  },

  -- Comment plugin
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Buffer line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "thin",
          always_show_bufferline = false,
          show_buffer_close_icons = false,
          show_close_icon = false,
          color_icons = true,
        },
        highlights = {
          background = {
            fg = "#6272A4",
            bg = "#282A36",
          },
          buffer_selected = {
            fg = "#F8F8F2",
            bg = "#44475A",
            bold = true,
            italic = false,
          },
          buffer_visible = {
            fg = "#6272A4",
            bg = "#282A36",
          },
          close_button = {
            fg = "#6272A4",
            bg = "#282A36",
          },
          close_button_visible = {
            fg = "#6272A4",
            bg = "#282A36",
          },
          close_button_selected = {
            fg = "#FF5555",
            bg = "#44475A",
          },
          tab_selected = {
            fg = "#F8F8F2",
            bg = "#44475A",
          },
          tab = {
            fg = "#6272A4",
            bg = "#282A36",
          },
          tab_close = {
            fg = "#FF5555",
            bg = "#282A36",
          },
          duplicate_selected = {
            fg = "#F8F8F2",
            bg = "#44475A",
            italic = true,
          },
          duplicate_visible = {
            fg = "#6272A4",
            bg = "#282A36",
            italic = true,
          },
          duplicate = {
            fg = "#6272A4",
            bg = "#282A36",
            italic = true,
          },
          modified = {
            fg = "#FFB86C",
            bg = "#282A36",
          },
          modified_selected = {
            fg = "#FFB86C",
            bg = "#44475A",
          },
          modified_visible = {
            fg = "#FFB86C",
            bg = "#282A36",
          },
          separator = {
            fg = "#282A36",
            bg = "#282A36",
          },
          separator_selected = {
            fg = "#44475A",
            bg = "#44475A",
          },
          separator_visible = {
            fg = "#282A36",
            bg = "#282A36",
          },
          indicator_selected = {
            fg = "#BD93F9",
            bg = "#44475A",
          },
        },
      })
    end,
  },

  -- Which-key for keybinding help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({})
    end,
  },

  -- Better indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "┊",
        },
        scope = {
          enabled = false,
        },
      })
    end,
  },

  -- Surround text objects
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
}

-- Setup lazy.nvim
require("lazy").setup(plugins, {
  ui = {
    border = "rounded",
  },
})

-- Key mappings
local keymap = vim.keymap.set

-- General mappings
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Resize windows
keymap("n", "<C-Up>", ":resize -2<CR>")
keymap("n", "<C-Down>", ":resize +2<CR>")
keymap("n", "<C-Left>", ":vertical resize -2<CR>")
keymap("n", "<C-Right>", ":vertical resize +2<CR>")

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>")
keymap("n", "<S-h>", ":bprevious<CR>")
keymap("n", "<leader>bd", ":bdelete<CR>")

-- File explorer
keymap("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Telescope mappings
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>")

-- Better indenting in visual mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")
keymap("x", "J", ":move '>+1<CR>gv-gv")
keymap("x", "K", ":move '<-2<CR>gv-gv")

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Save and quit shortcuts
keymap("n", "<leader>w", ":w<CR>")
keymap("n", "<leader>q", ":q<CR>")
keymap("n", "<leader>x", ":x<CR>")

-- Clear search highlighting
keymap("n", "<leader>/", ":nohlsearch<CR>")

-- Auto commands
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  pattern = "*",
  command = ":%s/\\s\\+$//e",
})

-- Auto-format on save for specific file types
autocmd("BufWritePre", {
  pattern = { "*.lua", "*.py", "*.js", "*.ts", "*.tsx", "*.jsx", "*.java" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Set filetype for specific files
autocmd({"BufRead", "BufNewFile"}, {
  pattern = { "*.conf", "*.config" },
  command = "set filetype=conf",
})

-- Java-specific settings
autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.colorcolumn = "120"  -- Java convention is often 120 chars
  end,
})
