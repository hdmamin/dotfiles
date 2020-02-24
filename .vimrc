" Show line numbers
set number
" Current line has global number, other numbers are relative to that line.
set relativenumber

" Allow backspace to delete before the cursor when entering insertion mode with "i".
set backspace=indent,eol,start

" Set tab size to 4 spaces
set ts=4

" Expand tabs to spaces
set expandtab

" Number of spaces to delete when hitting backspace after a tab
set softtabstop=4

" Indent to next line when writing code
set autoindent

" Menu UI for filename autocomplete
set wildmenu

" Load language-specific indentation files automatically
filetype indent on

" Highlight search matches
set hlsearch

" Python syntax highlighting
let python_highlight_all = 1

" Vim-Plug plugins
call plug#begin('~/.vim/plugged')
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'scrooloose/nerdtree'
Plug 'ap/vim-buftabline'
Plug '907th/vim-auto-save'
call plug#end()

" turn off rope due to freezing issue
let g:pymode_rope = 0

" Pylint config file
let g:pymode_options_max_line_length = 79 
let g:pymode_syntax_space_errors = 0
" (zR: open all, zM: close all, zo: open current, zc: close current)
let g:pymode_folding = 1
let g:pymode_lint_ignore = ["W391"]

syntax enable

" Open file menu sidebar with \n
map <leader>n :NERDTreeToggle<CR>

" Option-click allows cursor movement like in other text editors. 
" Top copy to clipboard, press fn key while highlighting text.
set mouse=a

" Underline the current line with dashes in normal mode
nnoremap <F5> yyp<c-v>$r-

" Copy highlighted text to clipboard with '' (2 single quotes)
vmap '' :w !pbcopy<CR><CR>

