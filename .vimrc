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

" Highlight search matches (incsearch updates after each typed letter).
set hlsearch
set incsearch

" Python syntax highlighting
let python_highlight_all = 1

" Vim-Plug plugins. Use command:
" :PlugInstall
call plug#begin('~/.vim/plugged')
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'scrooloose/nerdtree'
Plug 'ap/vim-buftabline'
Plug '907th/vim-auto-save'
Plug 'tpope/vim-surround'
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

" Use ctrl j/k to move lines down/up. Shift j/k causes problems in pycharm.
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Option-click allows cursor movement like in other text editors. 
" Top copy to clipboard, press fn key while highlighting text.
set mouse=a

" Underline the current line with dashes in normal mode
nnoremap <F5> yyp<c-v>$r-

" Copy highlighted text to clipboard with '' (2 single quotes)
vmap '' :w !pbcopy<CR><CR>

" In command line mode, scroll through previous commands that start with the
" text typed so far. Usually this only works with arrow keys, but this lets us
" do it with ctrl-p (prev) and ctrl-n (next).
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" In command mode, lets us use %% to get current working directory, e.g. :e %%/newfile.txt
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
