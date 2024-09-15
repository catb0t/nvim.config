vim9script

set number
set termguicolors
set background=dark

set tabstop=4

set expandtab
set autoindent
set shiftwidth=4

set clipboard+=unnamedplus
# vsplit
# set inccommand=nosplit
set updatetime=400
g:mapleader = ","


g:copilot_workspace_folders = ['~/projects/git/*']
g:copilot_python_interpreter = $HOME .. '/.local/venv/nvim/bin/python'


imap <silent><script><expr> <C-e> copilot#Accept("\<CR>")
g:copilot_no_tab_map = v:true

plug#begin()

Plug 'github/copilot.vim'
Plug 'tpope/vim-fugitive'
Plug 'girishji/vimcomplete'
Plug 'yegappan/lsp'

plug#end()

let lspOpts = #{autoHighlightDiags: v:true}
autocmd User LspSetup call LspOptionsSet(lspOpts)

let lspServers = [#{
	\	  name: 'pylsp',
	\	  filetype: ['py'],
	\	  path: 'pylsp',
	\	  args: []
	\ }]
autocmd User LspSetup call LspAddServer(lspServers)

call LspOptionsSet(#{
        \   aleSupport: v:false,
        \   autoComplete: v:true,
        \   autoHighlight: v:false,
        \   autoHighlightDiags: v:true,
        \   autoPopulateDiags: v:false,
        \   completionMatcher: 'case',
        \   completionMatcherValue: 1,
        \   diagSignErrorText: 'E>',
        \   diagSignHintText: 'H>',
        \   diagSignInfoText: 'I>',
        \   diagSignWarningText: 'W>',
        \   echoSignature: v:false,
        \   hideDisabledCodeActions: v:false,
        \   highlightDiagInline: v:true,
        \   hoverInPreview: v:false,
        \   ignoreMissingServer: v:false,
        \   keepFocusInDiags: v:true,
        \   keepFocusInReferences: v:true,
        \   completionTextEdit: v:true,
        \   diagVirtualTextAlign: 'above',
        \   diagVirtualTextWrap: 'default',
        \   noNewlineInCompletion: v:false,
        \   omniComplete: v:null,
        \   outlineOnRight: v:false,
        \   outlineWinSize: 20,
        \   semanticHighlight: v:true,
        \   showDiagInBalloon: v:true,
        \   showDiagInPopup: v:true,
        \   showDiagOnStatusLine: v:false,
        \   showDiagWithSign: v:true,
        \   showDiagWithVirtualText: v:false,
        \   showInlayHints: v:false,
        \   showSignature: v:true,
        \   snippetSupport: v:false,
        \   ultisnipsSupport: v:false,
        \   useBufferCompletion: v:false,
        \   usePopupInCodeAction: v:false,
        \   useQuickfixForLocations: v:false,
        \   vsnipSupport: v:false,
        \   bufferCompletionTimeout: 100,
        \   customCompletionKinds: v:false,
        \   completionKinds: {},
        \   filterCompletionDuplicates: v:false,
	\ })
