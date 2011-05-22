" ################################################
" #                                              #
" #         七彩映像(7color) 的 VIMRC            #
" #         http://www.7color.org                #
" #         Last modified:  2011-01-16           #
" #                                              #
" ################################################
                                                
" Set Common {{{1
set nocompatible                    "关闭 VI 兼容模式
" 依次尝试使用该列表编码,如果成功,则设置fileencoding为该值,失败使用encoding的值
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1  
set fileencoding=utf-8              " 设置此缓冲区所在文件的字符编码
set encoding=utf-8                  " 设置 Vim 内部使用的字符编码
set fileformat=unix                 " 给出当前缓冲区的 <EOL> 格式
set nobomb                          " 不使用 Unicode签名
set shortmess=atI                   " 启动的时候不显示那个援助索马里儿童的提示
set ssl                             " 路径中使用正斜线
set cc=81                           " 设置最大行宽
set clipboard+=unnamed              " 与Windows共享剪贴板
set helplang=cn,en                  " 使用中文帮助
set whichwrap=s,<,>,[,]             " 光标从行首和行末可以跳到另一行 
set sessionoptions-=curdir          " 不保存/恢复当前目录
set sessionoptions+=sesdir          " 保存/恢复会话文件所在的目录会成为当前目录 
set number                          " 显示行号
set showmatch                       " 插入括号时,短暂地跳转到匹配的对应括号
set tabstop=4                       " 设定 tab 长度为 4
set softtabstop=4                   " 使得按退格键时可以一次删掉 4 个空格
set shiftwidth=4                    " 设定 << 和 >> 命令移动时的宽度为 4
set expandtab                       " /
set smarttab                        " /
set si                              " 开启新行时使用智能自动缩进 (smartindent)
"set wrap                            " 改变文本显示的方式,超过窗口宽度的行将回绕
set hi=400                          " 历史记录数 (history)
" set nolz                            " 关闭延迟重画 (lazyredraw)
set so=7                            " 光标上下两侧最少保留的屏幕行数 (scrolloff)
set cmdheight=2                     " 命令行使用的屏幕行数
set laststatus=2                    " 总是显示状态行
set hidden                          " Change buffer - without saving
"set noerrorbells                   " 关闭错误信息响铃(默认关闭)
"set novisualbell                   " 关闭可视响铃代替鸣叫,置空错误铃声的终端代码(默认关闭)
set t_vb=                           " 置空错误铃声的终端代码
set showcmd                         " 在屏幕最后一行显示(部分的)命令
set mat=4                           " 显示配对括号的十分之一秒数(matchtime)
set nobackup                        " /
set nowb                            " / 关闭备份
set noswapfile                      " / 
set backspace=start,indent,eol      " 使回格键（backspace）正常处理indent, eol, start等
set ignorecase                      " 忽略大小写
set incsearch                       " 输入搜索内容时就显示搜索结果
set completeopt=menu,longest        " 代码补全时使用弹出窗口及插入匹配的最大公共串
set wildmenu                        " 增强模式中的命令行自动完成操作
set wildmode=longest:full,full      " 使用最大公共串补全,如果结果未变长,使用完成匹配补全
set formatoptions+=tcroql           " 控制 Vim 如何对文本进行排版
"set textwidth=80                   " 插入文本的最大宽度
"set cursorline                     " 突出显示当前行
"set cursorcolumn                   " 突出显示当前列
set viminfo='100,:200,<50,s10,h,n~/.viminfo     " 初始化时读入 viminfo 文件，退出 Vim 时写回
set foldenable                      " 开启折叠
set foldmethod=manual               " 手动建立折叠
"set foldmethod= marker             " 标志用于折叠
set listchars=tab:▸\ ,eol:$         " 设置tab,eol字符
"set keywordprg=pman
set ambiwidth=double                " 对"不明宽度"字符的的宽度设置为双倍字符宽度(中文字符宽度)
"set autoread                       " 当文件在VIM之外修改过,VIM里面没有的话,重新载入
set report=0                        " 报告改变行数的阈值,0时总是得到消息
set diffopt+=vertical,context:3     " diff模式选项(垂真分割,差异文周围不被折叠的行数)
if has('mouse')
    set mouse=a                     " 在所有模式下使用鼠标
endif

language messages zh_cn.utf-8       " 设置当前语言(locale)
" }}}
" Gui-running & Autocmd {{{1
" Gui-running {{{2
if has("gui_running")
  set guioptions=m                  " 使用菜单栏
  "set guioptions=t                 " 使用菜单项
  "set linespace=2                  " 设置行间距
  syntax enable                     " 开启语法高亮
  set hlsearch                      " 高亮搜索字符

  if has("win32")
    set guifont=Consolas:h9         " 设置字体
    "set guifontwide=YaHei_Consolas_Hybrid:h9
	set gfw=Yahei_Mono:h9:cGB2312
    source $VIMRUNTIME/delmenu.vim  " /
    source $VIMRUNTIME/menu.vim     " / 重置menu菜单
  else
    set guifont=DejaVu\ Sans\ Mono\ 9
  endif

  colorscheme molokai               " 配色方案
  set columns=104
  set lines=33
else
 " 防止退出时终端乱码e
  set t_fs=(B
  set t_IE=(B
  if &term =~ "256color"
    " 在不同模式下使用不同颜色的光标
    set cursorline
    colorscheme darkblue
    if &term =~ "xterm"
      silent !echo -ne "\e]12;HotPink\007"
      let &t_SI="\e]12;RoyalBlue1\007"
      let &t_EI="\e]12;HotPink\007"
      autocmd VimLeave * :!echo -ne "\e]12;green\007"
    endif
  else
    colorscheme default
    " 在Linux文本终端下非插入模式显示块状光标
    if &term == "linux"
       set t_ve+=[?6c
       autocmd InsertEnter * set t_ve-=[?6c
       autocmd InsertLeave * set t_ve+=[?6c
       autocmd VimLeave * set t_ve-=[?6c
    endif
  endif
endif
" Autocmd {{{2
if has("autocmd")
    " Enable filetype plugin
    filetype plugin indent on
    
    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    au!
    
    augroup myvimrchooks
        au!
        autocmd bufwritepost _vimrc source $MYVIMRC
    augroup END

    "autocmd FileType xhtml,html,vim,javascript setl shiftwidth=4
    "autocmd FileType vim,javascript setl tabstop=2
    "autocmd FileType xhtml,html setl tabstop=4
    "autocmd FileType css setl tabstop=2 noexpandtab
    "autocmd FileType php setl shiftwidth=4 | setl tabstop=4
    autocmd BufRead,BufNewFile *.js set ft=javascript.jquery
    autocmd BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
    autocmd FileType php compiler php
    autocmd FileType php map <buffer> <leader><space> <leader>cd:w<cr>:make %<cr>
    autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif      " 保存光标位置
    autocmd BufWinEnter *
    \ if &omnifunc == "" |
    \   setlocal omnifunc=syntaxcomplete#Complete |
    \ endif
else
    set autoindent      " 开启新行时,从当前行复制缩进距离
endif


" }}}
" Plugin configuration {{{1
" javascript.vim(syntax/) {{{2
let b:javascript_fold=1             " 打开javascript折叠(层数)
let javascript_enable_domhtmlcss=1  " 打开javascript对dom、html和css的支持

" mru.vim {{{2
let MRU_File = $HOME.'/_vim_mru'
let MRU_Exclude_Files = '^c:\\temp\\.*'
let MRU_Window_Height = 10
let MRU_Max_Menu_Entries = 9 
let MRU_Max_Entries = 10

" taglist.vim {{{2
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
"  来源 http://gist.github.com/476387
let tlist_html_settings = 'html;h:Headers;o:IDs;c:Classes'
let tlist_vimwiki_settings = 'wiki;h:Headers'
" map <F8> to toggle taglist window
nmap <silent> <F10> :TlistToggle<CR>

" winmanager.vim {{{2
let g:winManagerWindowLayout='FileExplorer|TagList'
nmap <silent> <F8> :WMToggle<CR>
"左栏top窗口
"map <c-w><c-f> :FirstExplorerWindow<CR> 
"左栏bottom窗口
"map <c-w><c-b> :BottomExplorerWindow<CR>
"map <c-w><c-t> :WMToggle<CR> 

" supertab.vim {{{2
let g:SuperTabRetainCompletionDuration = "session"
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabCrMapping = 1
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 1
let g:SuperTabNoCompleteBefore = ['\k']
let g:SuperTabNoCompleteAfter = [',', '\s', '(', ')']
" fencview.vim {{{2
let g:fencview_autodetect = 0  "打开文件时自动识别编码
"let g:fencview_checklines = 10 "检查前后10行来判断编码

" html.vim {{{2
let g:do_xhtml_mappings = 'yes'
let g:html_tag_case = 'lowercase'
let g:no_html_toolbar = 'yes'
let g:no_html_menu = 'yes'
let g:html_default_charset = 'utf-8'
let g:no_html_tab_mapping = 'yes'

"   indent/html.vim {{{2
let g:html_indent_inctags = "html,body,head,tbody,p,li,dd,marquee"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
" echofunc.vim
"let g:EchoFuncLangsUsed = ["php"] 

" php-doc.vim {{{2
inoremap <A-/> <ESC>:call PhpDocSingle()<CR>
nnoremap <A-/> :call PhpDocSingle()<CR>
vnoremap <A-/> :call PhpDocRange()<CR>

" bufexplorer.vim {{{2
let g:bufExplorerDefaultHelp=1
let g:bufExplorerDetailedHelp=0
let g:bufExplorerSortBy='mru'
"let g:bufExplorerWidth = 60
let g:winManagerWidth = 36
nmap <F4> :BufExplorer<CR>

" NERDTree.vim {{{2
let NERDShutUp = 1
" map <F9> :NERDTreeToggle<CR>

" NERD_tree_project.vim
map <F9> :ToggleNERDTree<CR>

" NERD_commenter.vim
let NERDSpaceDelims=1       " 让注释符与语句之间留一个空格
let NERDCompactSexyComs=1   " 多行注释时样子更好看

" mark.vim {{{2
hi MarkWord1  ctermbg=Cyan     ctermfg=Black  guibg=#8CCBEA    guifg=Black
hi MarkWord2  ctermbg=Green    ctermfg=Black  guibg=#A4E57E    guifg=Black
hi MarkWord3  ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
hi MarkWord4  ctermbg=Red      ctermfg=Black  guibg=#FF7272    guifg=Black
hi MarkWord5  ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black
hi MarkWord6  ctermbg=Blue     ctermfg=Black  guibg=#9999FF    guifg=Black

" vimtweak.dll {{{2
"启动程序时开始背景透明
"au GUIENTER * call libcallnr("vimtweak.dll","SetAlpha",222)
"透明/不透明窗口
nmap <C-F6> :call libcallnr("vimtweak.dll","SetAlpha",255)<CR> 
nmap <F6> :call libcallnr("vimtweak.dll","SetAlpha",210)<CR>
"最大化/小化窗口
nmap <C-F7> :call libcallnr("vimtweak.dll", "EnableMaximize", 0)<CR>
nmap <F7> :call libcallnr("vimtweak.dll", "EnableMaximize", 1)<CR>

" php.vim {{{2
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
let php_folding=0                   " 使用代码折叠        
let php_strict_blocks=1             "         
"let php_fold_arrays=1              " 折叠数组        
let php_baselib=1                   " 高亮基础函数库        
"let php_sql_query = 1               " 高亮字符串中的SQL关键字        
"let php_htmlInStrings = 0           " 不高亮字符串中的HTML关键字        
let php_alt_properties = 0          "        
let php_highlight_quotes = 1        
let PHP_autoformatcomment = 1       " 自动格式注释        
let php_sync_method = -1        

" dbext.vim {{{2
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

" zencoding.vim {{{2
let g:user_zen_settings = {  
\  'html' : {
\    'filters' : 'html',
\    'indentation' : ' '
\  },
\  'php' : {  
\    'extends' : 'html',  
\    'filters' : 'c',  
\  },  
\  'css' : {
\    'filters' : 'fc',
\  },
\  'javascript' : {
\    'snippets' : {
\      'jq' : "$(function() {\n\t${cursor}${child}\n});",
\      'jq:each' : "$.each(arr, function(index, item)\n\t${child}\n});",
\      'fn' : "(function() {\n\t${cursor}\n})();",
\      'tm' : "setTimeout(function() {\n\t${cursor}\n}, 100);",
\    },
\  },
\}

" grep.vim {{{2
" let Grep_Path = $VIMRUNTIME . '\tools\grep.exe'
" let Fgrep_Path = $VIMRUNTIME . '\tools\fgrep.exe'
" let Egrep_Path = $VIMRUNTIME . '\tools\egrep.exe'
" let Agrep_Path = $VIMRUNTIME . '\tools\agrep.exe'
" let Grep_Find_Path = $VIMRUNTIME . '\tools\find.exe'
" let Grep_Xargs_Path = $VIMRUNTIME . '\tools\xargs.exe'
let Grep_Path = 'D:\cygwin\bin\grep.exe'
let Fgrep_Path = 'D:\cygwin\bin\fgrep.exe'
let Egrep_Path = 'D:\cygwin\bin\egrep.exe'
let Grep_Find_Path = 'D:\cygwin\bin\find.exe'
let Grep_Xargs_Path = 'D:\cygwin\bin\xargs.exe'
let Grep_Skip_Dirs = '.svn'
nmap <silent> <F3> :Grep<CR>

" xptemplate.vim {{{2
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


" vimwiki.vim {{{2
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
" 转换换行符
let g:vimwiki_list_ignore_newlin = 1
" 增加可以在vimwiki中使用的HTML标签
let g:vimwiki_valid_html_tags = "em,b,i,s,u,sub,sup,kbd,br,hr"
" 待办事项进度0%,25%,50%,75%,100%
let g:vimwiki_listsyms="01234"
" 生成HTML时忽略指定文件列表(自定义,demo\/格式为指定忽略文件夹)
let g:vimwiki_ignore_html_files = '404.html,search.html,about.html,demo\/'


" calendar.vim {{{2
"let g:calendar_monday = 1
let g:calendar_mark = 'left-fit'
let g:calendar_mruler = '一月,二月,三月,四月,五月,六月,七月,八月,九月,十月,十一月,十二月'
let g:calendar_wruler = '日 一 二 三 四 五 六'
let g:calendar_navi_label = '上月,今天,下月'

" sessionman.vim {{{2
" (默认为保存)
" let sessionman_save_on_exit = 0
" }}}
" User-defined {{{1
" tag 目录设置
nmap <silent> <F11> :set tags+=$HOME/tags<CR>
"au BufEnter *.php,*.phtml setlocal tags+=$HOME/tags

" ZendFramework Tag 相关
nmap <C-F12> :call system("ctags --php-kinds=-v --languages=php --tag-relative=no -f " . $HOME . "/tags -R " . getcwd() . "/library/Zend --fields=+lS")<CR>
nmap <F12> :call system("ctags --exclude=Zend --languages=php --tag-relative=yes -R --fields=+lS")<CR> 
" vimwiki 相关
map <C-F2> :exec 'silent !start cmd /k "cd /d "'.VimwikiGet('path_html').'" & sync"'<CR>
map <S-F2> :VimwikiAll2HTML<CR>
map <F2> :Vimwiki2HTML<CR>

" 查看当前光标下关键词的PHP手册
nmap K :silent ! start http://php.net/<cword><CR> 

" 快速切换缓冲区
map <C-k> <C-W>k
map <C-j> <C-W>j
map <C-h> <C-W>h
map <C-l> <C-W>l

" nmap <C-D> <C-W>q

" 在输入模式下移动光标，彻底抛弃方向键
" inoremap <C-h> <left>
" inoremap <C-j> <C-o>gj
" inoremap <C-k> <C-o>gk
" inoremap <C-l> <Right>
" 插入模式下模拟HOME/END键
" inoremap <C-a> <Home>
" inoremap <C-e> <End>
" inoremap <C-e> <C-o>A
" inoremap <C-a> <C-o>I

" 插入模式下模拟eclipse在当前行上/下开启新行
imap <C-Enter> <C-o>o
imap <S-Enter> <C-o>O

" nnoremap <tab> %
" vnoremap <tab> %

" 自定义函数调用GIT进行pull push操作(-nargs=1 只接受一个参数)
command! -nargs=? Git call CallGit(<f-args>)
" args改为...则为多参数,参考Timestamp()
function! CallGit(...)
  if a:0 == 1
    if a:1 == 'wiki'
      exec 'silent !start cmd /k "cd /d E:/wiki/ & sync"'
    elseif a:1 == 'vim'
      exec 'silent !start cmd /k "cd /d D:/vim/ & sync"'
    endif
  else 
      exec 'silent !start cmd /k "cd /d "'.VimwikiGet('path_html').'" & sync"'
  endif
endfunction

"选择模式下缩进
vnoremap < <gv
vnoremap > >gv

" 设置状态栏样式
function! CurrectDir()
    let curdir = substitute(getcwd(), "", "", "g")
    return curdir
endfunction
set statusline=\ [File]\ %F%m%r%h[%{&fileencoding}]\ %w\ \ [PWD]\ %r%{CurrectDir()}%h\ \ %=[Line]\ %l,%c\ %=\ %P

" PHP 语法检查
"function! PHP_CheckSyntax()
"    setlocal makeprg=D:/Zend/ZendServer/bin/php.exe\ -l\ -n\ -d\ html_errors=off
"    setlocal shellpipe=>

    " Use error format for parsing PHP error output
"    setlocal errorformat=%m\ in\ %f\ on\ line\ %l
"    make %
"endfunction
" map <F5> :call PHP_CheckSyntax()<CR>
" 重载当前文件
nmap <F5> :e!<CR>
nmap <silent> tt :tabnew<CR>
nmap ta ggVG

"以空格代替zc,zo实现折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> 

"自动补全(){}[]<>
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
endfunction

" 单/双引号自动补全
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
nnoremap <BS> c

" ctrl + a (全选)
"noremap <C-A> ggVG
"inoremap <C-A> <C-O>ggVG
" ctrl + s (保存)
"imap <C-s> <esc>:w<CR>:echo expand("%f") . " saved."<CR>
"vmap <C-s> <esc>:w<CR>:echo expand("%f") . " saved."<CR>
"nmap <C-s> :w<CR>:echo expand("%f") . " saved."<CR>
" ctrl + n (新建)
"imap <C-n> <esc>:enew!<CR>
"nmap <C-n> :enew!<CR>
"vmap <C-n> <esc>:enew!<CR>
" ctrl + c (复制)
"vmap <C-c> "+y
" ctrl + x (剪切)
"vmap <C-x> "+x
" ctrl + z (撤消)
"inoremap <C-z> <C-O>u
"nnoremap <C-z> u
" ctrl + y (重做)
"inoremap <C-y> <C-O><C-R>
"nnoremap <C-y> <C-R>
" ctrl + v (粘贴)
"nnoremap <C-v> a<space>"+gP<esc>
" 兼容ClipX
inoremap <C-v> <C-O>"+gP
"map <C-V> "+pa<Esc>
"map! <C-V> <Esc>"+pa
" ctrl + f (查找)
"imap <C-f> <esc>:/
"nmap <C-f> :/
" ctrl + r (替换)
"imap <C-r> <esc>:%s/
"vmap <C-r> <esc>:%s/
"nmap <C-r> :%s/
" ctrl + o (打开)
"imap <C-o> <C-O>:e
"vmap <C-o> <esc>:e
"nmap <C-o> :e 

" 最后修改时间戳,能够自动调整位置
function! TimeStamp(...)
	let sbegin = ''
    let send = ''
    let pend = ''
	if a:0 >= 1
        let sbegin = '' . a:1
        let sbegin = substitute(sbegin, '*', '\\*', "g")
		let sbegin = sbegin . '\s*'
	endif
	if a:0 >= 2
		let send = send . a:2
        let pend = substitute(send, '*', '\\*', "g")
    endif
	let pattern = 'Last modified: .\+' . pend
	let pattern = '^\s*' . sbegin . pattern . '\s*$'
	let now = strftime('%Y-%m-%d %H:%M:%S',localtime())

	let row = search(pattern, 'n')
	if row  == 0
        let row = line('$')
        let now = a:1 . 'Last modified:  ' . now . send
        call append(row, now)
	else
		let curstr = getline(row)
		let col = match( curstr , 'Last')
		let now = a:1 . 'Last modified:  ' . now . send
		call setline(row, now)
	endif
endfunction

" Last Change:  2010-07-29 18:50:39
"au BufWritePre _vimrc call TimeStamp('" ')
"au BufWritePre *.js,*.css,*.php call TimeStamp('/* ', ' */')
"au BufWritePre *.html,*.htm,*.phtml call TimeStamp('<!-- ', ' -->')
"au BufWritePre *.sh call TimeStamp('# ')
"au BufWritePre *.txt call TimeStamp(' ')
au BufWritePre *.wiki call TimeStamp('<!-- ', ' -->')

" 映射Alt-0_9快捷键快速选择标签
for temp in [0,1,2,3,4,5,6,7,8,9]
    exe 'map <A-' . temp . '> ' . temp . 'gt'
endfor
" }}}
" Leader commands {{{1 
let mapleader = ','                                     " 设置mapleader使用`,`代替 `\`
" mark.vim support regex
nmap <silent> <leader>hl <Plug>MarkSet
vmap <silent> <leader>hl <Plug>MarkSet
nmap <silent> <leader>hh <Plug>MarkClear
vmap <silent> <leader>hh <Plug>MarkClear
nmap <silent> <leader>hr <Plug>MarkRegex
vmap <silent> <leader>hr <Plug>MarkRegex
" 切换列表项开/关(vimwiki.vim)
nmap <leader>tt <Plug>VimwikiToggleListItem
" 快速修改 .vimrc
nmap <leader>v :tabf $MYVIMRC<CR>
" 切换至当前目录
nmap <leader>cd :cd %:p:h<CR>
" 快速保存
nmap <leader>s :w! <CR>
" 默认程序打开当前缓冲区文件
nmap <Leader>x :silent ! start "1" "%:p"<CR>      
" 重新加载 .vimrc
"nmap <Leader>s :source $MYVIMRC<CR>
" 显示行号
nmap <leader>nu :set nu<CR>
" 显示相对于光标所在的行的行号
nmap <leader>rnu :set rnu<CR>
" 删除 ^M
nmap <Leader>dm mmHmn:%s/<C-V><CR>//ge<CR>'nzt'm
" 停止`hlsearch`的选项的高亮显示
nmap <silent> <leader><CR> :noh<CR>
" 快速切换`set list` or `set nolist`
nmap <leader>l :set list!<CR>
" 在当前缓冲区打开当前文件目录下的文件
map <leader>ee :e <C-R>=expand("%:p:h") . "/" <CR>
" 以水平分割的方式打开当前文件目录下的文件
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
" 以垂直分割的方式打开当前文件目录下的文件
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
" 以Tab标签的方式打开当前文件目录下的文件
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>
" 折叠标签
nmap <leader>ft Vatzf
"搜索选中文字,全文高度搜索
"vnoremap <silent> <leader>/ y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"vnoremap <silent> <leader>? y?<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
" }}}
" vim: nowrap fdm=marker
