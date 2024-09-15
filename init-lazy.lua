-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- NOTE: recommended by averms/black-nvim
-- first, create a venv in ~/.local/venv/nvim, then
-- vim.cmd("let g:python3_host_prog = $HOME . '/.local/venv/nvim/bin/python'")

vim.cmd("set number")
vim.cmd("set termguicolors")
vim.cmd("set background=dark")

vim.cmd("set tabstop=4")

vim.cmd("set expandtab")
-- vim.cmd("set smartindent")
vim.cmd("set autoindent")
vim.cmd("set shiftwidth=4")

vim.cmd("set clipboard+=unnamedplus")
vim.cmd("vsplit")
vim.cmd("set inccommand=nosplit")
vim.cmd("set updatetime=400")
vim.cmd('let mapleader=",')


vim.cmd("let g:copilot_workspace_folders = ['~/projects/git/*']")
vim.cmd("let g:copilot_python_interpreter = $HOME . '/.local/venv/nvim/bin/python'")

vim.keymap.set('i', '<C-e>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

-- vim.api.nvim_set_keymap(
--     't',
--     '<Leader><ESC>',
--     '<C-\\><C-n>',
--     {noremap = true}
-- )

require("lazy").setup({
  spec = {
    -- add your plugins here
    { "github/copilot.vim" },
    { "folke/tokyonight.nvim" },
    { 'mfussenegger/nvim-lint' },

    -- { 'averms/black-nvim', build = ":UpdateRemotePlugins" },

    { 'akinsho/bufferline.nvim', requires = 'nvim-tree/nvim-web-devicons'},

    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/nvim-cmp' },
    { 'neovim/nvim-lspconfig',
        config = function()
            require('lspconfig').pylsp.setup{}
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c", "python", "rust", "json", "lua", "vim", "vimdoc", "query", "elixir", "javascript", "html" },
                sync_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                fold = { enable = true },
              })
        end
    },

    {
        'nvimdev/lspsaga.nvim',
        config = function()
        	require('lspsaga').setup({})
    	end,
    	dependencies = {
        	'nvim-treesitter/nvim-treesitter', -- optional
        	'nvim-tree/nvim-web-devicons',     -- optional
    	}
    },

    {
	    "L3MON4D3/LuaSnip",
    	-- follow latest release.
    	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    	-- install jsregexp (optional!).
    	build = "make install_jsregexp"
    },

    { 'saadparwaiz1/cmp_luasnip' },

    {
        'nvim-telescope/telescope.nvim', version = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
          -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },

    {
      'sudormrfbin/cheatsheet.nvim',

      dependencies = {
        {'nvim-telescope/telescope.nvim'},
        {'nvim-lua/popup.nvim'},
        {'nvim-lua/plenary.nvim'},
      }
    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "tokyonight" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
  }
})


require("bufferline").setup{}

-- vim.cmd("colorscheme nightfly")
-- vim.cmd("colorscheme PaperColor")

vim.cmd("colorscheme tokyonight")

vim.o.completeopt = 'menuone,noselect,noinsert,popup'
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    callback = function()
        vim.cmd('TSEnable highlight indent fold injections')
    end
})


vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function()
      local save_cursor = vim.fn.getpos(".")
      pcall(function() vim.cmd [[%s/\s\+$//e]] end)
      vim.fn.setpos(".", save_cursor)
    end,
})


require('lint').linters_by_ft = {
    markdown = {'vale',},
    python = {'pylint'},
}


-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--     callback = function()
--
--     -- try_lint without arguments runs the linters defined in `linters_by_ft`
--     -- for the current filetype
--         -- require("lint").try_lint()
--     end,
-- })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = {"*.py"},
    callback = function()
        vim.cmd('exe "!black %"')
        vim.cmd('exe "!isort --profile black %"')
        vim.cmd('redraw')
    end,
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    callback = function()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
                return
            end
        end
        vim.diagnostic.open_float({
            scope = "cursor",
            focusable = false,
            close_events = {
                "CursorMoved",
                "CursorMovedI",
                "BufHidden",
                "InsertCharPre",
                "WinLeave",
            },
        })
    end
})
