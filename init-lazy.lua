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



vim.cmd("let g:python3_host_prog = $HOME . '/.local/venv/nvim/bin/python'")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    { "folke/tokyonight.nvim", opts = {} },
    { 'mfussenegger/nvim-lint', opts = {} },
    { 'fisadev/vim-isort', opts = {} },

    use 'averms/black-nvim'

    use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'

    use ({
        'nvimdev/lspsaga.nvim',
        after = 'nvim-lspconfig',
        config = function()
            require('lspsaga').setup({})
        end,
    })

	use {
        'nvim-treesitter/nvim-treesitter',
        run = function()

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})


vim.cmd("set number")
vim.cmd("set termguicolors")
vim.cmd("set background=dark")
-- vim.cmd("colorscheme nightfly")
-- vim.cmd("colorscheme PaperColor")
vim.cmd("colorscheme tokyonight")

vim.cmd("set tabstop=4")

vim.cmd("set expandtab")
-- vim.cmd("set smartindent")
vim.cmd("set autoindent")
vim.cmd("set shiftwidth=4")

vim.cmd("set clipboard+=unnamedplus")
vim.cmd("vsplit")

vim.opt.termguicolors = true
-- require("bufferline").setup{}

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


vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = {"*.py"},
    callback = function()
      vim.cmd('exe "!isort --profile black %"')
      vim.cmd('exe "!black %"')
      vim.cmd('redraw')
    end,
})

-- require('lint').linters_by_ft = {
--     markdown = {'vale',},
--     python = {'pylint'},
-- }


-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--     callback = function()
--
--     -- try_lint without arguments runs the linters defined in `linters_by_ft`
--     -- for the current filetype
--         require("lint").try_lint()
--     end,
-- })

