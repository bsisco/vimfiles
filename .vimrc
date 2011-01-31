set nocompatible
autocmd!
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
set ffs=unix,dos,mac "Default file types
set encoding=utf-8
set cpoptions=$cF
set guioptions-=T
filetype plugin indent on				" Let filetype plugins indent for me

""""" Searching and Patterns
set ignorecase							" search is case insensitive
set smartcase							" search case sensitive if caps on
set incsearch							" show best match so far

""""" Display
set background=dark						" I use dark background
set lazyredraw							" Don't repaint when scripts are running
set scrolloff=3							" Keep 3 lines below and above the cursor
set ruler								" line numbers and column the cursor is on
set nu!								    " Don't show line numbering
set ttyfast
set cmdheight=2
set sidescrolloff=3

""Set backup to a location
set backup
set backupdir=$HOME/temp/vim_backups/
set noswapfile

"""" Settings
set spell                               " Dynamic Spell Checking
set nohlsearch
set nocul
set ww=b,<,>,[,]
set nowrap
set undolevels=1000
set updatecount=100
set complete=.,w,b,u,U,t,i,d
set completeopt=longest,menuone
set linespace=0
set noerrorbells

""""" Messages, Info, Status
set shortmess+=a						" Use [+] [RO] [w] for modified, read-only, modified
set showcmd								" Display what command is waiting for an operator
set laststatus=2						" Always show statusline, even if only 1 window
set report=0							" Notify me whenever any lines have changed
set confirm								" Y-N-C prompt if closing with unsaved changes
set vb t_vb=							" Disable visual bell!  I hate that flashing.
"set statusline+=[%{strftime(\"%d/%m/%y\ -\ %H:%M\")}]

set statusline=%F%m%r%h%w\ [MODTIME=%{strftime(\"%c\",getftime(expand(\"%:p\")))}]\ [%{strftime(\"%d/%m/%y\ -\ %H:%M\")}]\ [POS=%l,%c]\ [COL=%c]\ [LINE=%l]\ [%p%%]\ [LEN=%L]\ 
set statusline+=[%{fugitive#statusline()}]
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

""""" Editing
set backspace=2							" Backspace over anything! (Super backspace!)
set matchtime=2							" For .2 seconds
set formatoptions-=tc					" I can format for myself, thank you very much
set tabstop=4							" Tab stop of 4
set shiftwidth=4						" sw 4 spaces (used on auto indent)
set softtabstop=4						" 4 spaces as a tab for bs/del
set matchpairs+=<:>						" specially for html
set showmatch							" Briefly jump to the previous matching parent
set noautoindent
set nosmartindent
set nocindent

""""" Coding
set history=100							" 100 Lines of history
set showfulltag							" Show more information while completing tags

"" set up tags
set tags=tags;/
set tags+=$HOME/.vim/tags/python.ctags

""""" Command Line
set wildmenu							" Autocomplete features in the status bar
set wildmode=longest:full,list
set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn


"" Set spacing guidelines for file types

"au BufRead,BufNewFile *.py  set ai ts=4 sw=4 sts=4 et tw=72 " Doc strs
au BufRead,BufNewFile *.js  set ai sw=2 sts=2 et tw=72 " Doc strs
au BufRead,BufNewFile *.html set ai sw=2 sts=2 et tw=72 " Doc strs
au BufRead,BufNewFile *.json set ai sw=4 sts=4 et tw=72 " Doc strs
"au BufNewFile *.html,*.py,*.pyw,*.c,*.h,*.json set fileformat=unix
au! BufRead,BufNewFile *.json setfiletype json

let python_highlight_all=1
syntax on

"" Bad whitespace
highlight BadWhitespace ctermbg=red guibg=red
"" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
"" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

set iskeyword+=.

""""" Movement
"" work more logically with wrapped lines
noremap j gj
noremap k gk

if has("gui_running")
    set guifont=Monaco:h8:cANSI
    syntax enable
    set t_Co=256
    set vb t_vb=							" Disable visual bell!  I hate that flashing.
    set clipboard=autoselect
    colorscheme ir_black
    set list listchars=tab:>·,trail:·,nbsp:­

    function! ScreenFilename()
        if has('amiga')
            return "s:.vimsize"
        elseif has('win32')
            return $HOME.'\_vimsize'
        else
            return $HOME.'/.vimsize'
        endif
    endfunction

    function! ScreenRestore()
        " Restore window size (columns and lines) and position
        " from values stored in vimsize file.
        " Must set font first so columns and lines are based on font size.
        let f = ScreenFilename()
        if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
            let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
            for line in readfile(f)
                let sizepos = split(line)
                if len(sizepos) == 5 && sizepos[0] == vim_instance
                    silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
                    silent! execute "winpos ".sizepos[3]." ".sizepos[4]
                    return
                endif
            endfor
        endif
    endfunction

    function! ScreenSave()
        " Save window size and position.
        if has("gui_running") && g:screen_size_restore_pos
            let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
            let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
                        \ (getwinposx()<0?0:getwinposx()) . ' ' .
                        \ (getwinposy()<0?0:getwinposy())
            let f = ScreenFilename()
            if filereadable(f)
                let lines = readfile(f)
                call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
                call add(lines, data)
            else
                let lines = [data]
            endif
            call writefile(lines, f)
        endif
    endfunction

    if !exists('g:screen_size_restore_pos')
        let g:screen_size_restore_pos = 1
    endif
    if !exists('g:screen_size_by_vim_instance')
        let g:screen_size_by_vim_instance = 1
    endif
    autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
    autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
else
    colorscheme zenburn " could use tango2 here as well
endif

"" tab labels show the filename without path(tail)
set guitablabel=%N/\ %t\ %M

"""" Windows
if exists(":tab")						" Try to move to other windows if changing buf
    set switchbuf=useopen,usetab
else									" Try other windows & tabs if available
    set switchbuf=useopen
endif

""""" Autocommands
if has("autocmd")
    "" Restore cursor position
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

        "" Filetypes (au = autocmd)
        au FileType helpfile set nonumber      " no line numbers when viewing help
        au FileType helpfile nnoremap <buffer><cr> <c-]>   " Enter selects subject
        au FileType helpfile nnoremap <buffer><bs> <c-T>   " Backspace to go back

        "" When using mutt, text width=72
        au FileType cpp,c,java,sh,pl,php,py,asp  set autoindent
        au FileType cpp,c,java,sh,pl,php,py,asp  set smartindent
        au FileType cpp,c,java,sh,pl,php,py,asp  set cindent
        au FileType py set foldmethod=indent
        au FileType py set textwidth=79  " PEP-8 friendly
        au FileType py inoremap # X#
        au FileType py set expandtab
        au FileType py set omnifunc=pythoncomplete#Complete
        autocmd BufRead,BufNewFile,FileReadPost *.py source ~/vimfiles/ftplugin/python.vim
        autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
        autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    endif

    function! GetPythonTextWidth()
        if !exists('g:python_normal_text_width')
            let normal_text_width = 79
        else
            let normal_text_width = g:python_normal_text_width
        endif

        if !exists('g:python_comment_text_width')
            let comment_text_width = 72
        else
            let comment_text_width = g:python_comment_text_width
        endif

        let cur_syntax = synIDattr(synIDtrans(synID(line("."), col("."), 0)), "name")
        if cur_syntax == "Comment"
            return comment_text_width
        elseif cur_syntax == "String"
            " Check to see if we're in a docstring
            let lnum = line(".")
            while lnum >= 1 && synIDattr(synIDtrans(synID(lnum, col([lnum, "$"]) - 1, 0)), "name") == "String"
                if match(getline(lnum), "\\('''\\|\"\"\"\\)") > -1
                    " Assume that any longstring is a docstring
                    return comment_text_width
                endif
                let lnum -= 1
            endwhile
        endif

        return normal_text_width
    endfunction
    augroup pep8
        au!
        autocmd CursorMoved,CursorMovedI * :if &ft == 'python' | :exe 'setlocal textwidth='.GetPythonTextWidth() | :endif
    augroup END

"" NerdTree Ignores these
"" filetypes
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$'] "'\.vim$', 
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeShowBookmarks=1


"" Obvious mode settings
let g:obviousModeInsertHi = 'term=reverse ctermbg=52'
let g:obviousModeCmdWinHi = 'term=reversse ctermbg=22'

"" TagList Plugin Configuration
let Tlist_Ctags_Cmd='\ctags57\ctags.exe' " point taglist to ctags
let Tlist_GainFocus_On_ToggleOpen = 1      " Focus on the taglist when its toggled
let Tlist_Close_On_Select = 1              " Close when something's selected
let Tlist_Use_Right_Window = 1             " Project uses the left window
let Tlist_File_Fold_Auto_Close = 1         " Close folds for inactive files
let Tlist_Enable_Fold_Column=1


""set autowrite       " auto saves changes when quitting and swiching buffer
set expandtab       " tabs are converted to spaces

""set nu!
let maplocalleader=','
if version >= 600
    set foldenable
    set foldmethod=indent
    set foldlevel=100
endif
""set statusline=%F%m%r%h%w\ [MODTIME=%{strftime(\"%c\",getftime(expand(\"%:p\")))}]\ [POS=%l,%c]\ [COL=%c]\ [LINE=%l]\ [%p%%]\ [LEN=%L]\ [%{strftime(\"%d/%m/%y\ -\ %H:%M\")}]
let g:screen_size_restore_pos = 1
let g:screen_size_by_vim_instance = 1

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*=\s.*\s=\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*=' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^=]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*=\s*\zs.*'))
    Tabularize/=/l1
    normal! 0
    call search(repeat('[^=]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Cope
"" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" " Do :help cope if you are unsure what cope is. It's super useful!
"inoremap <expr> <CR>        pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <Down>      pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr> <Up>        pumvisible() ? "\<C-p>" : "\<Up>"
"inoremap <expr> <PageDown>  pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
"inoremap <expr> <PageUp>    pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

inoremap <C-Space> <C-x><C-o>
map <silent><C-Left> <C-T>
map <silent><C-Right> <C-]>
map <F1> :previous<cr>
map <F2> :next<cr>
map <LocalLeader>v :vsp ~/.vimrc<cr>
map <LocalLeader>e :e ~/.vimrc<cr>
map <LocalLeader>u :source ~/.vimrc<cr>
map <LocalLeader>ft :%s/	/    /g<cr>
map  :Lodgeit<cr>
map <LocalLeader>ps :ConqueTermSplit Powershell.exe<cr>
map <LocalLeader>py :ConqueTermSplit ipython<cr>
map <LocalLeader>pvs :ConqueTermVSplit Powershell.exe<cr>
map <LocalLeader>pvy :ConqueTermVSplit ipython<cr>
map <LocalLeader>cp :botright cope<cr>
map <LocalLeader>n :cn<cr>
map <LocalLeader>p :cp<cr>
nmap . .`[
map  <LocalLeader>cc <plug>NERDCommenterComment<cr>
map  <LocalLeader>c<space> <plug>NERDCommenterToggle<cr>
map  <LocalLeader>cm <plug>NERDCommenterMinimal<cr>
map  <LocalLeader>cs <plug>NERDCommenterSexy<cr>
map  <LocalLeader>ci <plug>NERDCommenterInvert<cr>
map  <LocalLeader>cy <plug>NERDCommenterYank<cr>
map  <LocalLeader>cl <plug>NERDCommenterAlignLeft<cr>
map  <LocalLeader>cb <plug>NERDCommenterAlignBoth<cr>
map  <LocalLeader>cn <plug>NERDCommenterNest<cr>
map  <LocalLeader>cu <plug>NERDCommenterUncomment<cr>
map  <LocalLeader>c$ <plug>NERDCommenterToEOL<cr>
map  <LocalLeader>cA <plug>NERDCommenterAppend<cr>
nmap <LocalLeader>nt <Esc>:tabnew<CR>
nmap <LocalLeader>tn <Esc>:tabn<CR>
nmap <LocalLeader>tp <Esc>:tabp<CR>
nmap <LocalLeader>tl :set list!<cr>
nmap <LocalLeader>cd :cd%:p:h<cr>
nmap <LocalLeader>lcd :lcd%:p:h<cr>
nmap <LocalLeader>h <C-W>h<Esc>
nmap <LocalLeader>w <C-W>w<Esc>
nmap <LocalLeader>l <C-W>l<Esc>
nmap <LocalLeader>j <C-W>j<Esc>
nmap <LocalLeader>k <C-W>k<Esc>
nmap q: :q
nmap <LocalLeader>fo :%foldopen!<cr>
nmap <LocalLeader>fc :%foldclose!<cr>
nmap <LocalLeader>tt :Tlist<cr>
nmap <LocalLeader>nn :NERDTreeToggle<cr>
nmap <LocalLeader>be :MiniBufExplorer<cr>
nmap <LocalLeader>cb :CMiniBufExplorer<cr>
nmap <LocalLeader>ub :UMiniBufExplorer<cr>
nmap <LocalLeader>tb :TMiniBufExplorer<cr>
nmap <LocalLeader>gs :Gstatus<cr>
nmap <LocalLeader>gb :Gblame<cr>
nmap <LocalLeader>gc :Gcommit -m<cr>
nmap <LocalLeader>gm :Gmove<cr>
nmap <LocalLeader>gg :Ggrep<cr>
"nmap <LocalLeader>gr :Gread<cr>
nmap <LocalLeader>gp :Gsplit<cr>
nmap <LocalLeader>gl :Glog<cr>
nmap <LocalLeader>grm :Gremove<cr>
nmap <F11> 1G=G
imap <F11> <ESC>1G=Ga
nmap <F11> 1G=G
map <F11> <ESC>1G=Ga
