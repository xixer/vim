" disable VI's compatible mode.. use VIM's commpatible mode
set nocompatible

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8
set fileformat=unix

"confirm on file not save and only read
"set confirm

"增强模式中的命令行自动完成操作 
set wildmenu 

" 启动的时候不显示那个援助索马里儿童的提示 
set shortmess=atI 

" 制表符为4 
set tabstop=4 

" 统一缩进为4 
set softtabstop=4 
set shiftwidth=4 

" 路径中使用正斜线
set ssl

" 设置最大行宽
set cc=81

"与Windows共享剪贴板
set clipboard+=unnamed

" use chinese help
set helplang=cn,en

" Set mapleader(代替 \ )
let mapleader = ","
let g:mapleader = ","

"打开javascript折叠(层数)
let b:javascript_fold=1
"打开javascript对dom、html和css的支持
let javascript_enable_domhtmlcss=1

"set autochdir
set whichwrap=s,<,>,[,] " 光标从行首和行末可以跳到另一行 
" Setting seesionoptions
set sessionoptions-=curdir  
set sessionoptions+=sesdir 

source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

language messages zh_CN.utf-8
"突出显示当前行,列
"set nocursorline nocursorcolumn 
"set cursorline
"set cursorline cursorcolumn 
" set gui options  guioptions-->menu
if has("gui_running")
  set guioptions=m
  "set guioptions=t
  
  "line-height
  "set linespace=2
  if has("win32")
    set guifont=Consolas:h9
    "set guifontwide=YaHei_Consolas_Hybrid:h9
	set gfw=Yahei_Mono:h9:cGB2312
  else
    set guifont=DejaVu\ Sans\ Mono\ 9
    set fileencoding=utf-8
  endif
  let g:zenburn_alternate_Visual = 1
  let g:zenburn_alternate_Include = 1
  let g:zenburn_alternate_Error = 1

  " set color schema
  "colorscheme oceandeep
  colorscheme molokai
  "colorscheme slate

  " winpos
  set columns=104
  set lines=33
else
  set t_Co=256
  colorscheme darkblue
endif

" Enable filetype plugin
filetype plugin on
filetype indent on

" Enable syntax highlight
syntax enable

" Show line number
set nu

" show matching bracets
set showmatch

" Basic editing options
set expandtab
set shiftwidth=2

au FileType xhtml,html,python,vim,javascript setl shiftwidth=2
au FileType python,vim,javascript setl tabstop=2
au FileType xhtml,html setl tabstop=4
au FileType css setl tabstop=2 noexpandtab
au FileType java,php setl shiftwidth=4
au FileType java,php setl tabstop=4
au BufRead,BufNewFile *.js set ft=javascript.jquery
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

set smarttab
set lbr
set tw=0

"Auto indent
set ai

" Smart indet
set si

" C-style indeting
set cindent

" Wrap lines
set wrap

" Sets how many lines of history VIM har to remember
set history=400

" Set to auto read when a file is changed from the outside
"set autoread

" Have the mouse enabled all the time:
set mouse=a

" Do not redraw, when running macros.. lazyredraw
set lz

" set 7 lines to the curors - when moving vertical..
set so=7

" The commandbar is 2 high
set cmdheight=2

" Change buffer - without saving
set hid

" Ignore case when searching
set ignorecase
set incsearch

" Set magic on
set magic

" No sound on errors.
set noerrorbells
set novisualbell
set t_vb=

"show cmd
set showcmd

" How many tenths of a second to blink
set mat=4

" Highlight search things
set hlsearch

" Turn backup off
set nobackup
set nowb
set noswapfile

" smart backspace
set backspace=start,indent,eol

"关闭代码提示预览窗口
set completeopt=longest,menu

" Set up automatic formatting
set formatoptions+=tcqlro
" Set maximum text width (for wrapping)
set textwidth=120

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" taglist.vim
let Tlist_Auto_Highlight_Tag = 1
let Tlist_Auto_Open = 0
let Tlist_Auto_Update = 1
let Tlist_Close_On_Select = 0
let Tlist_Compact_Format = 0
let Tlist_Display_Prototype = 0
let Tlist_Display_Tag_Scope = 1
let Tlist_Enable_Fold_Column = 0
" 如果只有一个buffer，kill窗口也kill掉buffer
"let Tlist_Exit_OnlyWindow = 0
"使taglist只显示当前文件tag，其它文件的tag都被折叠起来(同时显示多个文件中的tag时)
"let Tlist_File_Fold_Auto_Close = 0
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Hightlight_Tag_On_BufEnter = 1
let Tlist_Inc_Winwidth = 0
let Tlist_Max_Submenu_Items = 1
let Tlist_Max_Tag_Length = 30
let Tlist_Process_File_Always = 0
let Tlist_Show_Menu = 0
"不同时显示多个文件的tag，只显示当前文件的
let Tlist_Show_One_File = 1
let Tlist_Sort_Type = "order"
let Tlist_Use_Horiz_Window = 0
"let Tlist_Use_Right_Window = 1
"let Tlist_Use_Left_Window = 1
"let Tlist_WinWidth = 40
let tlist_php_settings = 'php;c:class;i:interfaces;d:constant;f:function'

" map <F8> to toggle taglist window
nmap <silent> <F10> :TlistToggle<CR>

" winmanager.vim
let g:winManagerWindowLayout='FileExplorer|TagList'
nmap <silent> <F8> :WMToggle<CR>
"左栏top窗口
"map <c-w><c-f> :FirstExplorerWindow<CR> 
"左栏bottom窗口
"map <c-w><c-b> :BottomExplorerWindow<CR>
"map <c-w><c-t> :WMToggle<CR> 


" supertab.vim
let g:SuperTabRetainCompletionType = 2
let g:SuperTabDefaultCompletionType = "<C-X><C-O>" 

" fencview.vim
let g:fencview_autodetect = 0  "打开文件时自动识别编码
"let g:fencview_checklines = 10 "检查前后10行来判断编码

" html.vim
let g:do_xhtml_mappings = 'yes'
let g:html_tag_case = 'lowercase'
let g:no_html_toolbar = 'yes'
let g:no_html_menu = 'yes'
let g:html_default_charset = 'utf-8'
let g:no_html_tab_mapping = 'yes'

" echofunc.vim
"let g:EchoFuncLangsUsed = ["php"] 

" php-doc.vim
inoremap <A-/> <ESC>:call PhpDocSingle()<CR>
nnoremap <A-/> :call PhpDocSingle()<CR>
vnoremap <A-/> :call PhpDocRange()<CR>

" bufexplorer.vim
let g:bufExplorerDefaultHelp=1
let g:bufExplorerDetailedHelp=0
let g:bufExplorerSortBy='mru'
"let g:bufExplorerWidth = 60
let g:winManagerWidth = 36
nmap <F4> :BufExplorer<CR>

" NERDTree.vim
" NERD Commenter
let NERDShutUp = 1
map <F9> :NERDTreeToggle<CR>

" mark.vim
nmap <silent> <leader>hl <Plug>MarkSet
vmap <silent> <leader>hl <Plug>MarkSet
nmap <silent> <leader>hh <Plug>MarkClear
vmap <silent> <leader>hh <Plug>MarkClear
nmap <silent> <leader>hr <Plug>MarkRegex
vmap <silent> <leader>hr <Plug>MarkRegex

hi MarkWord1  ctermbg=Cyan     ctermfg=Black  guibg=#8CCBEA    guifg=Black
hi MarkWord2  ctermbg=Green    ctermfg=Black  guibg=#A4E57E    guifg=Black
hi MarkWord3  ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
hi MarkWord4  ctermbg=Red      ctermfg=Black  guibg=#FF7272    guifg=Black
hi MarkWord5  ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black
hi MarkWord6  ctermbg=Blue     ctermfg=Black  guibg=#9999FF    guifg=Black

"启动程序时开始背景透明
"au GUIENTER * call libcallnr("vimtweak.dll","SetAlpha",222)
"透明/不透明窗口
nmap <C-t><C-t> :call libcallnr("vimtweak.dll","SetAlpha",210)<CR> 
nmap <C-t>Y :call libcallnr("vimtweak.dll","SetAlpha",255)<CR>
"最大化/小化窗口
nmap <C-m>M :call libcallnr("vimtweak.dll", "EnableMaximize", 0)<CR>
nmap <C-m><C-m> :call libcallnr("vimtweak.dll", "EnableMaximize", 1)<CR>

"php.vim
let php_alt_construct_parents = 1
let php_show_semicolon =1     "使分号更为明显
let php_smart_semicolon=0     "使分号与return,break语法一致
let php_highlight_quotes=1    "使引号与字符串颜色一致
let php_special_vars = 1
let php_special_functions = 0
let php_alt_comparisons = 0
let php_alt_assignByReference = 0
let php_alt_arrays = 0
let php_oldStyle = 0
let php_fold_heredoc = 0
let php_short_tags = 0
let php_noShortTags = 1
let PHP_removeCRwhenUnix = 1
let php_large_file = 3000        
"let php_smart_members = 0        
"let php_smart_semicolon = 0        
"let php_show_pcre = 0        
let php_folding=0                  " 使用代码折叠        
let php_strict_blocks=1             "         
"let php_fold_arrays=1              " 折叠数组        
let php_baselib=1                   " 高亮基础函数库        
"let php_sql_query = 1               " 高亮字符串中的SQL关键字        
"let php_htmlInStrings = 0           " 不高亮字符串中的HTML关键字        
let php_alt_properties = 0          "        
let php_highlight_quotes = 1        
let PHP_autoformatcomment = 1       " 自动格式注释        
let php_sync_method = -1        
"let g:AutoComplPop_NotEnableAtStartup = 1

" dbext.vim
"let g:sql_type_default     = 'mysql'
"let g:dbext_default_use_sep_result_buffer = 1
"let g:dbext_default_display_cmd_line = 1
"let g:dbext_default_buffer_lines = 10

"let g:dbext_default_type   = 'mysql'
"let g:dbext_default_user   = 'root'
"let g:dbext_default_passwd = 'root'
"let g:dbext_default_dbname = 'test'
"let g:dbext_default_host   = 'localhost'

"let g:dbext_default_use_result_buffer = 1
"let g:use_sep_result_buffer = 1
"let dbext_default_MYSQL_bin                = 'mysql'
"let dbext_default_MYSQL_cmd_header         = ''
"let dbext_default_MYSQL_cmd_terminator     = ''
"let dbext_default_MYSQL_cmd_options        = '--default-character-set=utf8'
"let dbext_default_MYSQL_version            = '5'
"let dbext_default_display_cmd_line         = 0
"let dbext_default_delete_temp_file         = 1

" zencoding.vim
let g:user_zen_settings = {  
\  'php' : {  
\    'extends' : 'html',  
\    'filters' : 'c',  
\  },  
\  'xml' : {  
\    'extends' : 'html',  
\  },  
\  'haml' : {  
\    'extends' : 'html',  
\  },  
\}

" grep.vim
let Grep_Path = $VIMRUNTIME . '\tools\grep.exe'
let Fgrep_Path = $VIMRUNTIME . '\tools\fgrep.exe'
let Egrep_Path = $VIMRUNTIME . '\tools\egrep.exe'
let Agrep_Path = $VIMRUNTIME . '\tools\agrep.exe'
let Grep_Find_Path = $VIMRUNTIME . '\tools\find.exe'
let Grep_Xargs_Path = $VIMRUNTIME . '\tools\xargs.exe'
let Grep_Skip_Dirs = '.svn'
nmap <silent> <F3> :Grep<CR>

" xptemplate.vim
" avoid key conflict 
"let g:SuperTabMappingForward = '<Plug>supertabKey' 
" if nothing matched in xpt, try supertab 
"let g:xptemplate_fallback = '<Plug>supertabKey' 
" xpt uses <Tab> as trigger key 
"let g:xptemplate_key = '<Tab>' 
" " use <tab>/<S-tab> to navigate through pum. Optional 
let g:xptemplate_pum_tab_nav = 1 
" " xpt triggers only when you typed whole name of a snippet. Optional 
"let g:xptemplate_minimal_prefix = 'full'
"let g:xptemplate_brace_complete = '([{'
let g:xptemplate_bundle = 'javascript_jquery'
" ({等补全时为{},而非{  }
"let g:xptemplate_vars = 'SPop=&SParg='
let g:xptemplate_brace_complete=0


" vimwiki 
" 维基项目的配置 
let g:vimwiki_list = [{'path': 'E:/wiki/',  
      \ 'path_html': 'E:/github/7color.github.com/', 
      \ 'html_header': 'E:/wiki/template/header.tpl', 
      \ 'html_footer': 'E:/wiki/template/footer.tpl', 
      \ 'css_name': 'styles/base.css',
      \ 'diary_link_count': 8,
      \ 'diary_index': 'index'}] 
  
" 对中文用户来说，我们并不怎么需要驼峰英文成为维基词条 
let g:vimwiki_camel_case = 0 
  
" 标记为完成的 checklist 项目会有特别的颜色 
let g:vimwiki_hl_cb_checked = 1 
  
"menu 设置
let g:vimwiki_menu="Plugin.Vimwiki"

" 待办事项进度0%,25%,50%,75%,100%
let g:vimwiki_listsyms="01234"

" 生成HTML时忽略指定文件列表(自定义)
let g:vimwiki_ignore_html_files = '404.html,search.html,about.html'

" 切换列表项开/关
map <leader>tt <Plug>VimwikiToggleListItem

" calendar.vim
let g:calendar_monday = 1
let g:calendar_mark = 'left-fit'

" sessionman(默认为保存)
" let sessionman_save_on_exit = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> user-defined
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tag 目录设置
nmap <silent> <F11> :set tags+=$HOME/tags<CR>
"au BufEnter *.php,*.phtml setlocal tags+=$HOME/tags

nmap <C-F12> :call system("ctags --languages=php --tag-relative=no -f " . $HOME . "/tags -R " . getcwd() . "/library/Zend --fields=+lS")<CR>
nmap <F12> :call system("ctags --exclude=Zend --languages=php --tag-relative=yes -R --fields=+lS")<CR> 

" Fast editing of the .vimrc
map <leader>e :tabf $MYVIMRC<CR>
"map <leader>w :w! <CR>

map <C-F2> :exec 'silent !start cmd /k "cd /d "'.VimwikiGet('path_html').'" & sync"'<cr>
map <S-F2> :VimwikiAll2HTML<cr>
map <F2> :Vimwiki2HTML<cr> 

" no display cmd.exe
nmap <Leader>x :silent ! start "1" "%:p"<CR>
nmap K :silent ! start http://php.net/<cword><CR>
nmap <Leader>s :source $MYVIMRC<CR>

nmap <leader>nu :set nu<CR>
nmap <leader>rnu :set rnu<CR>

"选择模式下缩进
vnoremap < <gv
vnoremap > >gv

" Set statusline
function! CurrectDir()
    let curdir = substitute(getcwd(), "", "", "g")
    return curdir
endfunction
set statusline=\ [File]\ %F%m%r%h[%{&fileencoding}]\ %w\ \ [PWD]\ %r%{CurrectDir()}%h\ \ %=[Line]\ %l,%c\ %=\ %P
set laststatus=2

" Switch to current dir
map <leader>cd :cd %:p:h<CR>

"日期缩写
iab xdate <c-r>=strftime("%c")<CR>

"Remove the Windows ^M
noremap <Leader>dm mmHmn:%s/<C-V><CR>//ge<CR>'nzt'm

"Fast remove highlight search
nmap <silent> <leader><CR> :noh<CR>

" PHP syntax check
function! PHP_CheckSyntax()
    setlocal makeprg=D:/Zend/ZendServer/bin/php.exe\ -l\ -n\ -d\ html_errors=off
    setlocal shellpipe=>

    " Use error format for parsing PHP error output
    setlocal errorformat=%m\ in\ %f\ on\ line\ %l
    make %
endfunction

" Perform :PHP_CheckSyntax()
map <F5> :call PHP_CheckSyntax()<CR>

" autocmd
    fun! KeywordComplete()
    let left = strpart(getline('.'), col('.') - 2, 1)
    if left =~ "^$"
        return "\<Tab>"
    elseif left =~ ' $'
        return "\<Tab>"
    else
        return "\<C-N>"
    endfun
    inoremap <silent> <Tab> <C-R>=KeywordComplete()<CR>
    
"Restore cursor to file position in previous editing session(保存光标位置)
set viminfo='10,\"100,:20,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif    

set foldenable 
set foldmethod=manual 
"set foldmethod=marker 

set keywordprg=pman

"以空格代替zc,zo实现折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> 

"自动补全({["'
inoremap ( <c-r>=OpenPair('(')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { <c-r>=OpenPair('{')<CR>
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ <c-r>=OpenPair('[')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
"just for xml document, but need not for now.
"inoremap < <c-r>=OpenPair('<')<CR>
"inoremap > <c-r>=ClosePair('>')<CR>
function! OpenPair(char)
    let PAIRs = {
                \ '{' : '}',
                \ '[' : ']',
                \ '(' : ')',
                \ '<' : '>'
                \}
    let line = getline('.')
    let oL = len(split(line, a:char, 1))-1
    let cL = len(split(line, PAIRs[a:char], 1))-1

    let txt = strpart(line, col('.')-1)
    let ol = len(split(txt, a:char, 1))-1
    let cl = len(split(txt, PAIRs[a:char], 1))-1

    if oL>=cL || (oL<cL && ol>=cl)
        return a:char . PAIRs[a:char] . "\<Left>"
    else
        return a:char
    endif
endfunction
function! ClosePair(char)
    if getline('.')[col('.')-1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf

inoremap ' <c-r>=CompleteQuote("'")<CR>
inoremap " <c-r>=CompleteQuote('"')<CR>
function! CompleteQuote(quote)
    let ql = len(split(getline('.'), a:quote, 1))-1
    " a:quote length is odd.
    if (ql%2)==1
        return a:quote
    elseif getline('.')[col('.') - 1] == a:quote
        return "\<Right>"
    elseif '"'==a:quote && "vim"==&ft && 0==match(strpart(getline('.'), 0, col('.')-1), "^[\t ]*$")
        " for vim comment.
        return a:quote
    elseif "'"==a:quote && 0==match(getline('.')[col('.')-2], "[a-zA-Z0-9]")
        " for Name's Blog.
        return a:quote
    else
        return a:quote . a:quote . "\<Left>"
    endif
endfunction

" Move lines
nmap <C-Down> :<C-u>move .+1<CR>
nmap <C-Up> :<C-u>move .-2<CR>

imap <C-Down> <C-o>:<C-u>move .+1<CR>
imap <C-Up> <C-o>:<C-u>move .-2<CR>

vmap <C-Down> :move '>+1<CR>gv
vmap <C-Up> :move '<-2<CR>gv
"防止<esc>到normal mode时回退1格
"inoremap <Esc> <C-O>mp<Esc>`p

" ctrl + c,a,v,x,z(映射 复制,全选,粘贴,剪切,撤销)
nnoremap <BS> c
" ctrl + a
"noremap <C-A> ggVG
"inoremap <C-A> <C-O>ggVG
" ctrl + s

"imap <C-s> <esc>:w<CR>:echo expand("%f") . " saved."<CR>
"vmap <C-s> <esc>:w<CR>:echo expand("%f") . " saved."<CR>
"nmap <C-s> :w<CR>:echo expand("%f") . " saved."<CR>

" ctrl + n
"imap <C-n> <esc>:enew!<CR>
"nmap <C-n> :enew!<CR>
"vmap <C-n> <esc>:enew!<CR>
" ctrl + c
"vmap <C-c> "+y
" ctrl + x
"vmap <C-x> "+x
" ctrl + z
"inoremap <C-z> <C-O>u
"nnoremap <C-z> u
" ctrl + y
"inoremap <C-y> <C-O><C-R>
"nnoremap <C-y> <C-R>
" ctrl + v
"nnoremap <C-v> a<space>"+gP<esc>
"inoremap <C-v> <C-O>"+gP

"map <C-V> "+pa<Esc>
"map! <C-V> <Esc>"+pa

" ctrl + f
"imap <C-f> <esc>:/
"nmap <C-f> :/
" ctrl + r
"imap <C-r> <esc>:%s/
"vmap <C-r> <esc>:%s/
"nmap <C-r> :%s/
" ctrl + o
"imap <C-o> <C-O>:e
"vmap <C-o> <esc>:e
"nmap <C-o> :e 

" Last change用到的函数，返回时间，能够自动调整位置(参数1:保存文件时是否标记ft为help)
function! TimeStamp(...)
	let sbegin = ''
  if a:1 == 'false'
    let send = ''
  else
	  let send = ' vim:set tw=78 noet wrap ts=8 ft=help norl:'
  endif
    let pend = ''
	if a:0 >= 2
        let sbegin = '' . a:2
        let sbegin = substitute(sbegin, '*', '\\*', "g")
		let sbegin = sbegin . '\s*'
	endif
	if a:0 >= 3
		let send = send . a:3
        let pend = substitute(send, '*', '\\*', "g")
	endif
	let pattern = 'Last modified: .\+' . pend
	let pattern = '^\s*' . sbegin . pattern . '\s*$'
	let now = strftime('%Y-%m-%d %H:%M:%S',localtime())

	let row = search(pattern, 'n')
	if row  == 0
    let row = line('$')
    let now = a:2 . 'Last modified:  ' . now . send
    call append(row, now)
	else
		let curstr = getline(row)

		let col = match( curstr , 'Last')
		let now = a:2 . 'Last modified:  ' . now . send
		call setline(row, now)
	endif
endfunction

"" Last Change:  2010-07-29 18:50:39
"au BufWritePre _vimrc call TimeStamp('" ')

" * Last Change:  2010-07-29 18:50:39
"au BufWritePre *.js,*.css,*.php call TimeStamp('false', '/* ', ' */')
"au BufWritePre *.html,*.htm,*.phtml call TimeStamp('false', '<!-- ', ' -->')
"au BufWritePre *.rb,*.py,*.sh call TimeStamp('# ')
"au BufWritePre *.txt call TimeStamp('true', ' ')
au BufWritePre *.wiki call TimeStamp('false', '<!-- ', ' -->')

for temp in [0,1,2,3,4,5,6,7,8,9]
exe 'map <A-' . temp . '> ' . temp . 'gt'
endfor
