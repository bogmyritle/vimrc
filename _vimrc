"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vundle plugin 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible      
filetype off           
set rtp+=$HOME/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle, required
Plugin 'a.vim'
Plugin 'mru.vim'
Plugin 'gmarik/vundle'
Plugin 'vimwiki/vimwiki'
Plugin 'The-NERD-tree'
Plugin 'bogmyritle/hilight-c-functions'
Plugin 'The-NERD-Commenter'
Plugin 'molokai'
Plugin 'tagbar'
"Plugin 'better-snipmate-snippet'
Plugin 'snipmate'
Plugin 'bufexplorer.zip'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'ctrlp.vim'
Plugin 'Shougo/neocomplcache.vim'
"Plugin 'grep.vim'
Plugin 'bling/vim-airline'
Plugin 'autoclose'
"Plugin 'fencview.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'MattesGroeger/vim-bookmarks'
"Plugin 'altercation/vim-colors-solarized'
Plugin 'mattn/emmet-vim'
let g:fencview_autodetect=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Sets how many lines of history VIM har to remember
set history=400
set nolist
set listchars=tab:>-,trail:-
syntax on

"Enable filetype plugin
filetype on
filetype plugin on
filetype indent on
"Auto indent
set autoindent
"Smart indet
set smartindent 
"C-style indeting
set cindent
"Set to auto read when a file is changed from the outside
set autoread
"Have the mouse enabled all the time:
set mouse=a
"no wrap
set nowrap
"no toolbar
set go-=T
"show number 
set number

set completeopt=longest,menuone
"Set 7 lines to the curors - when moving vertical..
set so=7
"Turn on WiLd menu
set wildmenu
"Always show current position
set ruler
"Do not redraw, when running macros.. lazyredraw
set lz
"Change buffer - without saving
set hid
"Set backspace
set backspace=eol,start,indent
"Ignore case when searching
set ignorecase
set infercase
set incsearch
"Set magic on
set magic
"No sound on errors.
set noerrorbells visualbell t_vb=
"show matching bracets
set showmatch

"Highlight search things
set hlsearch
set dy=lastline
"set ch=2
"set laststatus=2   " Always show the statusline

"设置语言编码
set enc=utf-8
"set ambiwidth=double
let $LANG ='en_US'
""set helplang=cn
:source $VIMRUNTIME/delmenu.vim
set langmenu=en;
:source $VIMRUNTIME/menu.vim

"设置缩进大小
set tabstop=4
set shiftwidth=4

"使用space代替tab
set expandtab  

"no backup and swap file
set nobackup
set noswapfile

set lines=35 columns=88
set tags=tags;
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                autocmd     
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"autocmd GUIEnter * call libcallnr("vimtweak.dll", "SetAlpha", 225)  
"自动显示当前工作文件夹
autocmd BufEnter *.* pwd
"quickfix 
autocmd QuickfixCmdPost make call QfMakeConv()
"set no bell
autocmd GUIEnter * set visualbell t_vb=
autocmd GUIEnter * set autochdir 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                函数    
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! Install()
    exec "silent !git clone https://github.com/gmarik/vundle.git .vim/bundle/vundle"
    source $MYVIMRC
    exec "PluginInstall"
endfun
func! Compile()
    exec "ccl"
    exec "w"
    if &ft == 'c' || &ft == 'cpp'
        exec "make"
        exec "cw"
        if has('win32') || has('win32unix') || has('win64')
            exec "!%<"
        else
            exec "!./%<"
        endif
    elseif &ft == 'python'
        exec "pyfile %"
    elseif &ft =='java'
        exec "!javac %"
        exec "!java %<"
    endif
endfun

func! AddCscope()
    exec ":cs kill -1"
    let s:CurrentDir = getcwd()
    let s:CscopeAddString = "cs add " . s:CurrentDir . "/cscope.out " . s:CurrentDir
    :exe s:CscopeAddString
endfun

func! GenTag()
    exec "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=c++"
    "exec "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q "
endfun

func! GenDatabase()
    exec "!cscope -Rbk"
    call AddCscope()
    exec "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q "
endfun

func! Toggle_quickfix()
    if !exists('g:quickfixshow')
        let g:quickfixshow = 0
    endif

    if g:quickfixshow == 0
        exec "copen"
        let g:quickfixshow=1
    else
        exe 'ccl'
        let g:quickfixshow=0
    endif
endfun

func! Run()
    if has('win32') || has('win32unix') || has('win64')
        exec "!%<"
    else
        exec "!./%<"
    endif
endfun

function! QtMake()
    :exec "!qmake -project"
    :exec "!qmake"
    set makeprg=nmake
endfunction

function! QfMakeConv()
    let qflist = getqflist()
    for i in qflist
        let i.text = iconv(i.text, "cp936", "utf-8")
    endfor
    call setqflist(qflist)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                平台定义    
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('win32') || has('win32unix') || has('win64')
    set makeprg =cl\ %\ -O2\ -EHsc 
    "set termencoding=chinese
    source $VIMRUNTIME/mswin.vim
    behave mswin 
    nnoremap <silent> <F1> :silent ! start "C:\\Program Files\Internet Explorer\iexplore.exe" "http://www.google.com/search?hl=en&btnI=I\%27m+Feeling+Lucky&q=site\%3Amsdn.microsoft.com\%20<cword>"<CR>
else
    set makeprg=g++\ %\ -o\ %<
    "set makeprg=g++\ %\ water.cpp\ -framework\ OpenGL\ -framework\ GLUT\ -o\ %<
endif

if( has("gui_running"))
    color  molokai 
    if has('win32') || has('win32unix') || has('win64')
        set gfn=DejaVu_Sans_Mono_for_Powerline:h13
        "set gfn=Consolas_for_Powerline_FixedD:h14
        "set gfn=Liberation_Mono_for_Powerline:h14
        "set gfn=Megatops_ProCoder_1.0:h13
        "set gfw=Yahei_Mono:h13
        set gfw=Fixedsys
    else
        set gfn=Menlo:h22
        set linespace=3
        set transparency=10
        let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
    endif
else
    color  wombat256 
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                按键绑定    
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set mapleader
let mapleader = ","
let g:mapleader = ","

"Fast reloading of the .vimrc
map <leader>s :source $MYVIMRC<cr>
"Fast editing of .vimrc
map <leader>e :split $MYVIMRC<cr>
map z :nohl<cr>

"map <space><space> /

"方便到行首，方便到行尾
map <s-h> 0
map L $
"inoremap <C-Enter> <ESC>o
"inoremap <A-Enter> <ESC>A
inoremap <c-k> <up>
inoremap <c-j> <down>
inoremap <c-h> <left>
inoremap <c-l> <right>
"替换选中单词，很有用
map s viw"0P

"在窗口中切换
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
inoremap jk <esc>


imap<silent> <F2> <ESC> :pyfile $HOME/DropBox/codesnip/stock.py<cr>
nnoremap <silent> <F2> :pyfile $HOME/DropBox/codesnip/stock.py<cr>

imap<silent> <F3> <ESC> :NERDTreeToggle<cr>
nnoremap <silent> <F3> :NERDTreeToggle<cr>

imap<silent> <F4> <ESC> :MRU<CR>
nnoremap<silent> <F4> :MRU<CR>

nmap <silent><F6> :call Toggle_quickfix()<CR>
imap<silent> <f7> <ESC> :BufExplorerHorizontalSplit<CR>
nnoremap <silent> <f7> :BufExplorerHorizontalSplit<CR>
nnoremap <Leader><Space> :BufExplorerHorizontalSplit<CR>

imap<silent> <F8> <ESC> :Tagbar<CR>
nnoremap <silent> <F8> :Tagbar<CR>

imap <silent> <F5> <ESC> :call Compile()<CR>
nnoremap <silent> <F5> :call Compile()<CR>


nnoremap <silent> <m-o> :A<CR>
imap <silent> <m-o> <ESC> :A<CR>

nnoremap <silent> <F12> :call GenDatabase()<CR>
imap <silent> <c-F12> :call GenDatabase()<CR>

map <leader>n :tabnew<cr>
nnoremap <silent> <TAB> :tabnext<cr>
nnoremap <silent> <c-TAB> :tabprev<cr>
map <leader>, :cn<cr>
map <leader>. :cp<cr>
map <leader>j :tn<cr>
map <leader>k :tp<cr>

let wiki_1 = {}
let wiki_1.path = '~/Dropbox/vimwiki/'
let wiki_1.path_html = '~/public_html/wiki/'
let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp','java': 'java','cs': 'cs',}

let g:vimwiki_list_ignore_newline=1
let wiki_2 = {}
let wiki_2.path = '~/Dropbox/ReadingNote/'
let wiki_2.path_html = '~/public_html/ReadingNote/'
let wiki_2.nested_syntaxes = {'python': 'python', 'c++': 'cpp','java': 'java','cs': 'cs',}
let g:vimwiki_list = [wiki_1, wiki_2]
"tagbar
let g:tagbar_left = 1
let g:tagbar_width = 30
"air line
let g:airline_powerline_fonts = 1
let g:airline_theme='light'
"NeoComplCache
let g:neocomplcache_enable_at_startup = 1
highlight BookmarkLine ctermbg=194 ctermfg=NONE
let g:bookmark_highlight_lines = 1
nmap <silent> <leader>v :silent ! start "C:\\Program Files\Internet Explorer\iexplore.exe " %<CR>
:nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
:nnoremap <leader>g :grep -R <cWORD> .<cr>
