set mouse=v
set number
set relativenumber
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent

call plug#begin('~/.vim/plugged')
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'neoclide/coc.nvim', {'branch': 'release'}"
    Plug 'https://github.com/fannheyward/coc-pyright'
    Plug 'elliothatch/burgundy.vim'
    "themes"
    "Plug 'joshdick/onedark.vim'"
    "Plug 'Mofiqul/dracula.nvim'"
call plug#end()

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
colorscheme burgundy

" Automatically load pyright
let g:coc_global_extensions = ['coc-pyright'] 
" Disable auto-import suggestions for clarity, if desired
let g:coc_preferences_autoImportSuggest = 'none'


" Перемещение выделенного текста вверх
vnoremap <C-Up> :m '<-2<CR>gv=gv

" Перемещение выделенного текста вниз
vnoremap <C-Down> :m '>+1<CR>gv=gv

" let g:python3_host_prog="usr/bin/python3"


map <C-n> :NERDTreeToggle<CR>
hi Normal guibg=#330f25
let t:is_transparent = 0
function! Toggle_transparent()
    if t:is_transparent == 0
        hi Normal guibg=NONE ctermbg=NONE
        let t:is_transparent = 1
    else
        hi Normal guibg=#330f25 ctermbg=0
        let t:is_transparent = 0
    endif
endfunction
nnoremap <C-t> : call Toggle_transparent()<CR>

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" air-line
let g:airline_powerline_fonts = 1

" highlight
let g:lsp_cxx_hl_use_text_props = 1
let g:cpp_simple_highlight = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" Terminal Function
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
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

vnoremap <C-c> "+y
vnoremap <C-v> "+p

nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 6gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> 9gt
nnoremap <A-0> 10gt 

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
