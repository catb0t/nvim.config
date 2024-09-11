require 'plugins'


require 'nvim-treesitter'.setup( {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    },
    folds = {
        enable = true
    },
    injections = {
        enable = true
    },
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

vim.opt.termguicolors = true
require("bufferline").setup{}

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

require('lint').linters_by_ft = {
    markdown = {'vale',},
    python = {'pylint'},
}


vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
        require("lint").try_lint()
    end,
})

local cmp = require 'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
  end,
},
window = {
  completion = cmp.config.window.bordered(),
  documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),

sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'git' },
}, {
  { name = 'buffer' },
})
})
require("cmp_git").setup() ]]--

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').pylsp.setup( {
    capabilities = capabilities,

    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {enabled = false},
                pyflakes = {enabled = false},
                pylint = {enabled = false},
                yapf = {enabled = false},
                jedi_completion = {fuzzy = true},
                jedi_definition = {follow_builtin_imports = true},
                jedi_hover = {enabled = true},
                jedi_references = {follow_builtin_imports = true},
                jedi_signature_help = {enabled = true},
                jedi_symbols = {all_scopes = true},
                mccabe = {enabled = false},
                preload = {enabled = false},
                rope_completion = {enabled = false},
                rope_rename = {enabled = false},
            }
        }
    }

})
