" ============================================================================
" GENERAL SETTINGS
" ============================================================================
set mouse=a
set number
set relativenumber
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent

" Use the system clipboard on macOS
set clipboard=unnamedplus

" Diff options
set diffopt+=vertical
set diffopt+=iwhite
set diffopt+=hiddenoff
set diffopt+=foldcolumn:0
if has("patch-8.1.0360")
    set diffopt+=internal,algorithm:patience
    set diffopt+=indent-heuristic
endif

" ============================================================================
" TRUE COLOR
" ============================================================================
" Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" ============================================================================
" PLUGINS
" ============================================================================
call plug#begin('~/.vim/plugged')
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'https://github.com/fannheyward/coc-pyright'
    Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
    Plug 'elliothatch/burgundy.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'iamcco/markdown-preview.nvim'
    Plug 'github/copilot.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    "themes"
    Plug 'joshdick/onedark.vim'
    Plug 'Mofiqul/dracula.nvim'

    "Claude"
    Plug 'nvim-lua/plenary.nvim'
    Plug 'greggh/claude-code.nvim'

call plug#end()

" ============================================================================
" PLUGIN CONFIG: python-mode
" ============================================================================
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_print_as_function = 1
let g:pymode_syntax_highlight_equal_operator = 1
let g:pymode_syntax_highlight_stars_operator = 1
let g:pymode_syntax_highlight_self = 1
let g:pymode_syntax_indent_errors = 1
let g:pymode_syntax_space_errors = 1
let g:pymode_syntax_highlight_errors = 0

let g:pymode_syntax_builtin_objs = 1
let g:pymode_syntax_builtin_types = 1
let g:pymode_syntax_highlight_exceptions = 1
let g:pymode_syntax_highlight_async_await = 1
let g:pymode_syntax_highlight_class_objects = 1

let g:pymode_lint_on_write = 0
let g:pymode_options_colorcolumn = 0
let g:pymode_lint = 1

" ============================================================================
" PLUGIN CONFIG: coc.nvim
" ============================================================================
" Automatically load pyright
let g:coc_global_extensions = ['coc-pyright']
" Disable auto-import suggestions for clarity
let g:coc_preferences_autoImportSuggest = 'none'

" Diagnostics: do not show diagnostic signs while typing / in normal mode
let g:coc_disable_diagnostic_sign_in_insert = 1
let g:coc_disable_diagnostic_sign_in_normal = 1

" Disable inline virtual text and popups; show diagnostics in a float instead
let g:coc_user_config = {
  \ 'diagnostic.enable': v:true,
  \ 'diagnostic.virtualText': v:false,
  \ 'diagnostic.virtualTextCurrentLineOnly': v:false,
  \ 'diagnostic.displayByAle': v:false,
  \ 'diagnostic.checkCurrentLine': v:false,
  \ 'diagnostic.messageTarget': 'float',
  \ 'coc.preferences.diagnostic.enable': v:true,
  \ 'coc.preferences.diagnostic.displayByAle': v:false,
  \ 'pyright.diagnostics.disabled': ['reportUnusedImport', 'reportUnusedVariable', 'reportUnusedClass', 'reportUnusedFunction'],
  \ 'signature.enable': v:true,
  \ 'signature.target': 'float',
  \ }

" ============================================================================
" PLUGIN CONFIG: claude-code
" ============================================================================
lua << EOF
require('claude-code').setup({
  window = { position = 'botright', split_ratio = 1.0 },
})
-- Open Claude in a given layout: change the window in the config and toggle.
local cc = require('claude-code')
function _G.ClaudeOpen(position, ratio)
  cc.config.window.position = position
  cc.config.window.split_ratio = ratio
  cc.toggle()
end
EOF

" ============================================================================
" APPEARANCE
" ============================================================================
colorscheme burgundy
hi Normal guibg=#330f25

" Conceal highlight, reapplied on colorscheme changes
function! s:setup_conceal()
  hi Conceal guibg=NONE ctermbg=NONE
  hi Conceal guifg=#ff0000 ctermfg=48
  hi Conceal gui=underline cterm=underline
endfunction
augroup custom_conceal
  autocmd!
  autocmd ColorScheme * call s:setup_conceal()
  autocmd VimEnter * call s:setup_conceal()
augroup END

" Dark colors for diff
hi DiffAdd    guifg=#a8d1a8 guibg=#0d3d0d ctermfg=151 ctermbg=22
hi DiffChange guifg=#d1d1a8 guibg=#4a3d0d ctermfg=187 ctermbg=58
hi DiffDelete guifg=#d1a8a8 guibg=#4d0d0d ctermfg=181 ctermbg=52
hi DiffText   guifg=#ffffff guibg=#2a7d2a ctermfg=15  ctermbg=28

" ============================================================================
" PYTHON SYNTAX
" ============================================================================
" Simplified Python highlighting without conflicts
autocmd FileType python syntax keyword pythonBoolean True False None
autocmd FileType python syntax keyword pythonBuiltinType
    \ bool bytearray bytes dict float frozenset int list object
    \ set slice str tuple type complex range memoryview

autocmd FileType python syntax keyword pythonBuiltinFunc
    \ abs all any ascii bin bool breakpoint bytearray bytes
    \ callable chr classmethod compile complex delattr dict dir
    \ divmod enumerate eval exec filter float format frozenset
    \ getattr globals hasattr hash help hex id input int isinstance
    \ issubclass iter len list locals map max memoryview min next
    \ object oct open ord pow print property range repr reversed
    \ round set setattr slice sorted staticmethod str sum super
    \ tuple type vars zip import

" ============================================================================
" FUNCTIONS
" ============================================================================
" Terminal toggle
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        exec "resize +" . 8
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

" ============================================================================
" KEYMAPS
" ============================================================================
" Leader key (comma)
let mapleader = ","

" --- Window navigation ---
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Window resize (Cmd+arrows, 6 steps) ---
nnoremap <D-Left>  :vertical resize -6<CR>
nnoremap <D-Right> :vertical resize +6<CR>
nnoremap <D-Up>    :resize +6<CR>
nnoremap <D-Down>  :resize -6<CR>

" --- Tabs ---
nnoremap <leader>1 :tabn 1<CR>
nnoremap <leader>2 :tabn 2<CR>
nnoremap <leader>3 :tabn 3<CR>
nnoremap <leader>4 :tabn 4<CR>
nnoremap <leader>5 :tabn 5<CR>
nnoremap <leader>6 :tabn 6<CR>
nnoremap <leader>7 :tabn 7<CR>
nnoremap <leader>8 :tabn 8<CR>
nnoremap <leader>9 :tabn 9<CR>
nnoremap <leader>0 :tabn 10<CR>
" New tab with tt, vertical split with vv
nnoremap tt :tabnew<CR>
nnoremap vv :vsplit<CR>

" --- Terminal ---
nnoremap <C-t> :call TermToggle(12)<CR>
inoremap <C-t> <Esc>:call TermToggle(12)<CR>
tnoremap <C-t> <C-\><C-n>:call TermToggle(12)<CR>
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

" --- Clipboard (macOS) ---
vnoremap <D-c> "+y
nnoremap <D-c> V"+y
inoremap <D-c> <Esc>V"+y
nnoremap <D-v> "+p
vnoremap <D-v> "+p
inoremap <D-v> <C-r>+
cnoremap <D-v> <C-r>+

" --- Move selected text up/down (visual) ---
vnoremap <D-Up> :m '<-2<CR>gv=gv
vnoremap <D-Down> :m '>+1<CR>gv=gv

" --- Git / fugitive ---
nnoremap <leader>gdi :Gdiff<CR>
nnoremap <leader>gh :Gdiffsplit HEAD<CR>
nnoremap <leader>g- :Gdiffsplit HEAD~1<CR>
nnoremap <leader>g2 :Gdiffsplit HEAD~2<CR>
nnoremap <leader>g3 :Gdiffsplit HEAD~3<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gl :Git log --oneline<CR>
nnoremap <leader>gL :Gclog<CR>

" --- coc / LSP ---
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nnoremap <leader>gd :call CocAction('jumpDefinition', 'tabe')<CR>
nnoremap <leader>gt :call CocAction('jumpTypeDefinition', 'tabe')<CR>
nnoremap <leader>gi :call CocAction('jumpImplementation', 'tabe')<CR>
nnoremap <leader>gr :call CocAction('jumpReferences', 'tabe')<CR>
" Toggle diagnostics
nnoremap <leader>cd :call CocAction('diagnosticToggle')<CR>
" Show all diagnostics in a list
nnoremap <leader>cq :CocList diagnostics<CR>
" Toggle inlay hints
nnoremap <leader>ch :CocCommand document.toggleInlayHint<CR>

" --- Claude ---
" ,ci - horizontal full height; ,cv - vertical on the side
nnoremap <leader>ci :lua ClaudeOpen('botright', 1.0)<CR>
nnoremap <leader>cv :lua ClaudeOpen('botright vsplit', 0.4)<CR>

" --- NERDTree / fzf / markdown ---
map <C-n> :NERDTreeToggle<CR>
nnoremap <C-p> :Files<CR>
nnoremap <leader>md :MarkdownPreviewToggle<CR>

" ============================================================================
" MISC
" ============================================================================
let g:python3_host_prog="/usr/bin/python3"

" In Neovim Ctrl+T can conflict with the tag feature; disable matchit default
if has('nvim')
  let g:loaded_matchit = 1
endif
