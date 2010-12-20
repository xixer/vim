" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
autoload/mark.vim	[[[1
490
" Script Name: mark.vim
" Description: Highlight several words in different colors simultaneously. 
"
" Copyright:   (C) 2005-2008 by Yuheng Xie
"              (C) 2008-2010 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:  Ingo Karkat <ingo@karkat.de> 
"
" Dependencies:
"  - SearchSpecial.vim autoload script (optional, for improved search messages). 
"
" Version:     2.4.0
" Changes:
" 13-Jul-2010, Ingo Karkat
" - ENH: The MarkSearch mappings (<Leader>[*#/?]) add the original cursor
"   position to the jump list, like the built-in [/?*#nN] commands. This allows
"   to use the regular jump commands for mark matches, like with regular search
"   matches. 
"
" 19-Feb-2010, Andy Wokula
" - BUG: Clearing of an accidental zero-width match (e.g. via :Mark \zs) results
"   in endless loop. Thanks to Andy Wokula for the patch. 
"
" 17-Nov-2009, Ingo Karkat + Andy Wokula
" - BUG: Creation of literal pattern via '\V' in {Visual}<Leader>m mapping
"   collided with individual escaping done in <Leader>m mapping so that an
"   escaped '\*' would be interpreted as a multi item when both modes are used
"   for marking. Replaced \V with s:EscapeText() to be consistent. Replaced the
"   (overly) generic mark#GetVisualSelectionEscaped() with
"   mark#GetVisualSelectionAsRegexp() and
"   mark#GetVisualSelectionAsLiteralPattern(). Thanks to Andy Wokula for the
"   patch. 
"
" 06-Jul-2009, Ingo Karkat
" - Re-wrote s:AnyMark() in functional programming style. 
" - Now resetting 'smartcase' before the search, this setting should not be
"   considered for *-command-alike searches and cannot be supported because all
"   mark patterns are concatenated into one large regexp, anyway. 
"
" 04-Jul-2009, Ingo Karkat
" - Re-wrote s:Search() to handle v:count: 
"   - Obsoleted s:current_mark_position; mark#CurrentMark() now returns both the
"     mark text and start position. 
"   - s:Search() now checks for a jump to the current mark during a backward
"     search; this eliminates a lot of logic at its calling sites. 
"   - Reverted negative logic at calling sites; using empty() instead of != "". 
"   - Now passing a:isBackward instead of optional flags into s:Search() and
"     around its callers. 
"   - ':normal! zv' moved from callers into s:Search(). 
" - Removed delegation to SearchSpecial#ErrorMessage(), because the fallback
"   implementation is perfectly fine and the SearchSpecial routine changed its
"   output format into something unsuitable anyway. 
" - Using descriptive text instead of "@" (and appropriate highlighting) when
"   querying for the pattern to mark. 
"
" 02-Jul-2009, Ingo Karkat
" - Split off functions into autoload script. 

"- functions ------------------------------------------------------------------
function! s:EscapeText( text )
	return substitute( escape(a:text, '\' . '^$.*[~'), "\n", '\\n', 'ge' )
endfunction
" Mark the current word, like the built-in star command. 
" If the cursor is on an existing mark, remove it. 
function! mark#MarkCurrentWord()
	let l:regexp = mark#CurrentMark()[0]
	if empty(l:regexp)
		let l:cword = expand("<cword>")

		" The star command only creates a \<whole word\> search pattern if the
		" <cword> actually only consists of keyword characters. 
		if l:cword =~# '^\k\+$'
			let l:regexp = '\<' . s:EscapeText(l:cword) . '\>'
		elseif l:cword != ''
			let l:regexp = s:EscapeText(l:cword)
		endif
	endif

	if ! empty(l:regexp)
		call mark#DoMark(l:regexp)
	endif
endfunction

function! s:GetVisualSelection()
	let save_a = @a
	silent normal! gv"ay
	let res = @a
	let @a = save_a
	return res
endfunction
function! mark#GetVisualSelectionAsLiteralPattern()
	return s:EscapeText(s:GetVisualSelection())
endfunction
function! mark#GetVisualSelectionAsRegexp()
	return substitute(s:GetVisualSelection(), '\n', '', 'g')
endfunction

" Manually input a regular expression. 
function! mark#MarkRegex( regexpPreset )
	call inputsave()
	echohl Question
	let l:regexp = input('Input pattern to mark: ', a:regexpPreset)
	echohl None
	call inputrestore()
	if ! empty(l:regexp)
		call mark#DoMark(l:regexp)
	endif
endfunction

function! s:Cycle( ... )
	let l:currentCycle = g:mwCycle
	let l:newCycle = (a:0 ? a:1 : g:mwCycle) + 1
	let g:mwCycle = (l:newCycle < g:mwCycleMax ? l:newCycle : 0)
	return l:currentCycle
endfunction

" Set / clear matches in the current window. 
function! s:MarkMatch( indices, expr )
	for l:index in a:indices
		if w:mwMatch[l:index] > 0
			silent! call matchdelete(w:mwMatch[l:index])
			let w:mwMatch[l:index] = 0
		endif
	endfor

	if ! empty(a:expr)
		" Make the match according to the 'ignorecase' setting, like the star command. 
		" (But honor an explicit case-sensitive regexp via the /\C/ atom.) 
		let l:expr = ((&ignorecase && a:expr !~# '\\\@<!\\C') ? '\c' . a:expr : a:expr)

		" Info: matchadd() does not consider the 'magic' (it's always on),
		" 'ignorecase' and 'smartcase' settings. 
		let w:mwMatch[a:indices[0]] = matchadd('MarkWord' . (a:indices[0] + 1), l:expr, -10)
	endif
endfunction
" Set / clear matches in all windows. 
function! s:MarkScope( indices, expr )
	let l:currentWinNr = winnr()

	" By entering a window, its height is potentially increased from 0 to 1 (the
	" minimum for the current window). To avoid any modification, save the window
	" sizes and restore them after visiting all windows. 
	let l:originalWindowLayout = winrestcmd() 

	noautocmd windo call s:MarkMatch(a:indices, a:expr)
	execute l:currentWinNr . 'wincmd w'
	silent! execute l:originalWindowLayout
endfunction
" Update matches in all windows. 
function! mark#UpdateScope()
	let l:currentWinNr = winnr()

	" By entering a window, its height is potentially increased from 0 to 1 (the
	" minimum for the current window). To avoid any modification, save the window
	" sizes and restore them after visiting all windows. 
	let l:originalWindowLayout = winrestcmd() 

	noautocmd windo call mark#UpdateMark()
	execute l:currentWinNr . 'wincmd w'
	silent! execute l:originalWindowLayout
endfunction
" Mark or unmark a regular expression. 
function! mark#DoMark(...) " DoMark(regexp)
	let regexp = (a:0 ? a:1 : '')

	" clear all marks if regexp is null
	if empty(regexp)
		let i = 0
		let indices = []
		while i < g:mwCycleMax
			if !empty(g:mwWord[i])
				let g:mwWord[i] = ''
				call add(indices, i)
			endif
			let i += 1
		endwhile
		let g:mwLastSearched = ""
		call s:MarkScope(l:indices, '')
		return
	endif

	" clear the mark if it has been marked
	let i = 0
	while i < g:mwCycleMax
		if regexp == g:mwWord[i]
			if g:mwLastSearched == g:mwWord[i]
				let g:mwLastSearched = ''
			endif
			let g:mwWord[i] = ''
			call s:MarkScope([i], '')
			return
		endif
		let i += 1
	endwhile

	" add to history
	if stridx(g:mwHistAdd, "/") >= 0
		call histadd("/", regexp)
	endif
	if stridx(g:mwHistAdd, "@") >= 0
		call histadd("@", regexp)
	endif

	" choose an unused mark group
	let i = 0
	while i < g:mwCycleMax
		if empty(g:mwWord[i])
			let g:mwWord[i] = regexp
			call s:Cycle(i)
			call s:MarkScope([i], regexp)
			return
		endif
		let i += 1
	endwhile

	" choose a mark group by cycle
	let i = s:Cycle()
	if g:mwLastSearched == g:mwWord[i]
		let g:mwLastSearched = ''
	endif
	let g:mwWord[i] = regexp
	call s:MarkScope([i], regexp)
endfunction
" Initialize mark colors in a (new) window. 
function! mark#UpdateMark()
	if ! exists('w:mwMatch')
		let w:mwMatch = repeat([0], g:mwCycleMax)
	endif

	let i = 0
	while i < g:mwCycleMax
		if empty(g:mwWord[i])
			call s:MarkMatch([i], '')
		else
			call s:MarkMatch([i], g:mwWord[i])
		endif
		let i += 1
	endwhile
endfunction

" Return [mark text, mark start position] of the mark under the cursor (or
" ['', []] if there is no mark); multi-lines marks not supported. 
function! mark#CurrentMark()
	let line = getline(".")
	let i = 0
	while i < g:mwCycleMax
		if !empty(g:mwWord[i])
			" Note: col() is 1-based, all other indexes zero-based! 
			let start = 0
			while start >= 0 && start < strlen(line) && start < col(".")
				let b = match(line, g:mwWord[i], start)
				let e = matchend(line, g:mwWord[i], start)
				if b < col(".") && col(".") <= e
					return [g:mwWord[i], [line("."), (b + 1)]]
				endif
				if b == e
					break
				endif
				let start = e
			endwhile
		endif
		let i += 1
	endwhile
	return ['', []]
endfunction

" Search current mark. 
function! mark#SearchCurrentMark( isBackward )
	let [l:markText, l:markPosition] = mark#CurrentMark()
	if empty(l:markText)
		if empty(g:mwLastSearched)
			call mark#SearchAnyMark(a:isBackward)
			let g:mwLastSearched = mark#CurrentMark()[0]
		else
			call s:Search(g:mwLastSearched, a:isBackward, [], 'same-mark')
		endif
	else
		call s:Search(l:markText, a:isBackward, l:markPosition, (l:markText ==# g:mwLastSearched ? 'same-mark' : 'new-mark'))
		let g:mwLastSearched = l:markText
	endif
endfunction

silent! call SearchSpecial#DoesNotExist()	" Execute a function to force autoload.  
if exists('*SearchSpecial#WrapMessage')
	function! s:WrapMessage( searchType, searchPattern, isBackward )
		redraw
		call SearchSpecial#WrapMessage(a:searchType, a:searchPattern, a:isBackward)
	endfunction
	function! s:EchoSearchPattern( searchType, searchPattern, isBackward )
		call SearchSpecial#EchoSearchPattern(a:searchType, a:searchPattern, a:isBackward)
	endfunction
else
	function! s:Trim( message )
		" Limit length to avoid "Hit ENTER" prompt. 
		return strpart(a:message, 0, (&columns / 2)) . (len(a:message) > (&columns / 2) ? "..." : "")
	endfunction
	function! s:WrapMessage( searchType, searchPattern, isBackward )
		redraw
		let v:warningmsg = printf('%s search hit %s, continuing at %s', a:searchType, (a:isBackward ? 'TOP' : 'BOTTOM'), (a:isBackward ? 'BOTTOM' : 'TOP'))
		echohl WarningMsg
		echo s:Trim(v:warningmsg)
		echohl None
	endfunction
	function! s:EchoSearchPattern( searchType, searchPattern, isBackward )
		let l:message = (a:isBackward ? '?' : '/') .  a:searchPattern
		echohl SearchSpecialSearchType
		echo a:searchType
		echohl None
		echon s:Trim(l:message)
	endfunction
endif
function! s:ErrorMessage( searchType, searchPattern, isBackward )
	if &wrapscan
		let v:errmsg = a:searchType . ' not found: ' . a:searchPattern
	else
		let v:errmsg = printf('%s search hit %s without match for: %s', a:searchType, (a:isBackward ? 'TOP' : 'BOTTOM'), a:searchPattern)
	endif
	echohl ErrorMsg
	echomsg v:errmsg
	echohl None
endfunction

" Wrapper around search() with additonal search and error messages and "wrapscan" warning. 
function! s:Search( pattern, isBackward, currentMarkPosition, searchType )
	let l:save_view = winsaveview()

	" searchpos() obeys the 'smartcase' setting; however, this setting doesn't
	" make sense for the mark search, because all patterns for the marks are
	" concatenated as branches in one large regexp, and because patterns that
	" result from the *-command-alike mappings should not obey 'smartcase' (like
	" the * command itself), anyway. If the :Mark command wants to support
	" 'smartcase', it'd have to emulate that into the regular expression. 
	let l:save_smartcase = &smartcase
	set nosmartcase

	let l:count = v:count1
	let [l:startLine, l:startCol] = [line('.'), col('.')]
	let l:isWrapped = 0
	let l:isMatch = 0
	let l:line = 0
	while l:count > 0
		" Search for next match, 'wrapscan' applies. 
		let [l:line, l:col] = searchpos( a:pattern, (a:isBackward ? 'b' : '') )

"****D echomsg '****' a:isBackward string([l:line, l:col]) string(a:currentMarkPosition) l:count
		if a:isBackward && l:line > 0 && [l:line, l:col] == a:currentMarkPosition && l:count == v:count1
			" On a search in backward direction, the first match is the start of the
			" current mark (if the cursor was positioned on the current mark text, and
			" not at the start of the mark text). 
			" In contrast to the normal search, this is not considered the first
			" match. The mark text is one entity; if the cursor is positioned anywhere
			" inside the mark text, the mark text is considered the current mark. The
			" built-in '*' and '#' commands behave in the same way; the entire <cword>
			" text is considered the current match, and jumps move outside that text.
			" In normal search, the cursor can be positioned anywhere (via offsets)
			" around the search, and only that single cursor position is considered
			" the current match. 
			" Thus, the search is retried without a decrease of l:count, but only if
			" this was the first match; repeat visits during wrapping around count as
			" a regular match. The search also must not be retried when this is the
			" first match, but we've been here before (i.e. l:isMatch is set): This
			" means that there is only the current mark in the buffer, and we must
			" break out of the loop and indicate that no other mark was found. 
			if l:isMatch
				let l:line = 0
				break
			endif

			" The l:isMatch flag is set so if the final mark cannot be reached, the
			" original cursor position is restored. This flag also allows us to detect
			" whether we've been here before, which is checked above. 
			let l:isMatch = 1
		elseif l:line > 0
			let l:isMatch = 1
			let l:count -= 1

			" Note: No need to check 'wrapscan'; the wrapping can only occur if
			" 'wrapscan' is actually on. 
			if ! a:isBackward && (l:startLine > l:line || l:startLine == l:line && l:startCol >= l:col)
				let l:isWrapped = 1
			elseif a:isBackward && (l:startLine < l:line || l:startLine == l:line && l:startCol <= l:col)
				let l:isWrapped = 1
			endif
		else
			break
		endif
	endwhile
	let &smartcase = l:save_smartcase
	
	" We're not stuck when the search wrapped around and landed on the current
	" mark; that's why we exclude a possible wrap-around via v:count1 == 1. 
	let l:isStuckAtCurrentMark = ([l:line, l:col] == a:currentMarkPosition && v:count1 == 1)
	if l:line > 0 && ! l:isStuckAtCurrentMark
		let l:matchPosition = getpos('.')

		" Open fold at the search result, like the built-in commands. 
		normal! zv

		" Add the original cursor position to the jump list, like the
		" [/?*#nN] commands. 
		" Implementation: Memorize the match position, restore the view to the state
		" before the search, then jump straight back to the match position. This
		" also allows us to set a jump only if a match was found. (:call
		" setpos("''", ...) doesn't work in Vim 7.2) 
		call winrestview(l:save_view)
		normal! m'
		call setpos('.', l:matchPosition)

		if l:isWrapped
			call s:WrapMessage(a:searchType, a:pattern, a:isBackward)
		else
			call s:EchoSearchPattern(a:searchType, a:pattern, a:isBackward)
		endif
		return 1
	else
		if l:isMatch
			" The view has been changed by moving through matches until the end /
			" start of file, when 'nowrapscan' forced a stop of searching before the
			" l:count'th match was found. 
			" Restore the view to the state before the search. 
			call winrestview(l:save_view)
		endif
		call s:ErrorMessage(a:searchType, a:pattern, a:isBackward)
		return 0
	endif
endfunction

" Combine all marks into one regexp. 
function! s:AnyMark()
	return join(filter(copy(g:mwWord), '! empty(v:val)'), '\|')
endfunction

" Search any mark. 
function! mark#SearchAnyMark( isBackward )
	let l:markPosition = mark#CurrentMark()[1]
	let l:markText = s:AnyMark()
	call s:Search(l:markText, a:isBackward, l:markPosition, 'any-mark')
	let g:mwLastSearched = ""
endfunction

" Search last searched mark. 
function! mark#SearchNext( isBackward )
	let l:markText = mark#CurrentMark()[0]
	if empty(l:markText)
		return 0
	else
		if empty(g:mwLastSearched)
			call mark#SearchAnyMark(a:isBackward)
		else
			call mark#SearchCurrentMark(a:isBackward)
		endif
		return 1
	endif
endfunction

"- initializations ------------------------------------------------------------
augroup Mark
	autocmd!
	autocmd VimEnter * if ! exists('w:mwMatch') | call mark#UpdateMark() | endif
	autocmd WinEnter * if ! exists('w:mwMatch') | call mark#UpdateMark() | endif
	autocmd TabEnter * call mark#UpdateScope()
augroup END

" Define global variables and initialize current scope.  
function! s:InitMarkVariables()
	if !exists("g:mwHistAdd")
		let g:mwHistAdd = "/@"
	endif
	if !exists("g:mwCycleMax")
		let i = 1
		while hlexists("MarkWord" . i)
			let i = i + 1
		endwhile
		let g:mwCycleMax = i - 1
	endif
	if !exists("g:mwCycle")
		let g:mwCycle = 0
	endif
	if !exists("g:mwWord")
		let g:mwWord = repeat([''], g:mwCycleMax)
	endif
	if !exists("g:mwLastSearched")
		let g:mwLastSearched = ""
	endif
endfunction
call s:InitMarkVariables()
call mark#UpdateScope()

" vim: ts=2 sw=2
plugin/mark.vim	[[[1
209
" Script Name: mark.vim
" Description: Highlight several words in different colors simultaneously. 
"
" Copyright:   (C) 2005-2008 by Yuheng Xie
"              (C) 2008-2009 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:  Ingo Karkat <ingo@karkat.de> 
" Orig Author: Yuheng Xie <elephant@linux.net.cn>
" Contributors:Luc Hermitte, Ingo Karkat
"
" Dependencies:
"  - Requires Vim 7.1 with "matchadd()", or Vim 7.2 or higher. 
"  - mark.vim autoload script. 
" 
" Version:     2.3.2
" Changes:
" 17-Nov-2009, Ingo Karkat
"   - Replaced the (overly) generic mark#GetVisualSelectionEscaped() with
"     mark#GetVisualSelectionAsRegexp() and
"     mark#GetVisualSelectionAsLiteralPattern(). 
"
" 04-Jul-2009, Ingo Karkat
" - A [count] before any mapping either caused "No range allowed" error or just
"   repeated the :call [count] times, resulting in the current search pattern
"   echoed [count] times and a hit-enter prompt. Now suppressing [count] via
"   <C-u> and handling it inside the implementation. 
" - Now passing isBackward (0/1) instead of optional 'b' flag into functions. 
"   Also passing empty regexp to mark#MarkRegex() to avoid any optional
"   arguments. 
"
" 02-Jul-2009, Ingo Karkat
" - Split off functions into autoload script. 
" - Removed g:force_reload_mark. 
" - Initialization of global variables and autocommands is now done lazily on
"   the first use, not during loading of the plugin. This reduces Vim startup
"   time and footprint as long as the functionality isn't yet used. 
"
" 6-Jun-2009, Ingo Karkat
"  1. Somehow s:WrapMessage() needs a redraw before the :echo to avoid that a
"     later Vim redraw clears the wrap message. This happened when there's no
"     statusline and thus :echo'ing into the ruler. 
"  2. Removed line-continuations and ':set cpo=...'. Upper-cased <SID> and <CR>. 
"  3. Added default highlighting for the special search type. 
"
" 2-Jun-2009, Ingo Karkat
"  1. Replaced highlighting via :syntax with matchadd() / matchdelete(). This
"     requires Vim 7.2 / 7.1 with patches. This method is faster, there are no
"     more clashes with syntax highlighting (:match always has preference), and
"     the background highlighting does not disappear under 'cursorline'. 
"  2. Factored :windo application out into s:MarkScope(). 
"  3. Using winrestcmd() to fix effects of :windo: By entering a window, its
"     height is potentially increased from 0 to 1. 
"  4. Handling multiple tabs by calling s:UpdateScope() on the TabEnter event. 
"     
" 1-Jun-2009, Ingo Karkat
"  1. Now using Vim List for g:mwWord and thus requiring Vim 7. g:mwCycle is now
"     zero-based, but the syntax groups "MarkWordx" are still one-based. 
"  2. Added missing setter for re-inclusion guard. 
"  3. Factored :syntax operations out of s:DoMark() and s:UpdateMark() so that
"     they can all be done in a single :windo. 
"  4. Normal mode <Plug>MarkSet now has the same semantics as its visual mode
"     cousin: If the cursor is on an existing mark, the mark is removed.
"     Beforehand, one could only remove a visually selected mark via again
"     selecting it. Now, one simply can invoke the mapping when on such a mark. 
"  5. Highlighting can now actually be overridden in the vimrc (anywhere
"     _before_ sourcing this script) by using ':hi def'. 
"
" 31-May-2009, Ingo Karkat
"  1. Refactored s:Search() to optionally take advantage of SearchSpecial.vim
"     autoload functionality for echoing of search pattern, wrap and error
"     messages. 
"  2. Now prepending search type ("any-mark", "same-mark", "new-mark") for
"     better identification. 
"  3. Retired the algorithm in s:PrevWord in favor of simply using <cword>,
"     which makes mark.vim work like the * command. At the end of a line,
"     non-keyword characters may now be marked; the previous algorithm prefered
"     any preceding word. 
"  4. BF: If 'iskeyword' contains characters that have a special meaning in a
"     regex (e.g. [.*]), these are now escaped properly. 
"
" 01-Sep-2008, Ingo Karkat: bugfixes and enhancements
"  1. Added <Plug>MarkAllClear (without a default mapping), which clears all
"     marks, even when the cursor is on a mark.
"  2. Added <Plug>... mappings for hard-coded \*, \#, \/, \?, * and #, to allow
"     re-mapping and disabling. Beforehand, there were some <Plug>... mappings
"     and hard-coded ones; now, everything can be customized.
"  3. Bugfix: Using :autocmd without <bang> to avoid removing _all_ autocmds for
"     the BufWinEnter event. (Using a custom :augroup would be even better.)
"  4. Bugfix: Explicitly defining s:current_mark_position; some execution paths
"     left it undefined, causing errors.
"  5. Refactoring: Instead of calling s:InitMarkVariables() at the beginning of
"     several functions, just calling it once when sourcing the script.
"  6. Refactoring: Moved multiple 'let lastwinnr = winnr()' to a single one at the
"     top of DoMark().
"  7. ENH: Make the match according to the 'ignorecase' setting, like the star
"     command.
"  8. The jumps to the next/prev occurrence now print 'search hit BOTTOM,
"     continuing at TOP" and "Pattern not found:..." messages, like the * and
"     n/N Vim search commands.
"  9. Jumps now open folds if the occurrence is inside a closed fold, just like n/N
"     do. 
"
" 10th Mar 2006, Yuheng Xie: jump to ANY mark
" (*) added \* \# \/ \? for the ability of jumping to ANY mark, even when the
"     cursor is not currently over any mark
"
" 20th Sep 2005, Yuheng Xie: minor modifications
" (*) merged MarkRegexVisual into MarkRegex
" (*) added GetVisualSelectionEscaped for multi-lines visual selection and
"     visual selection contains ^, $, etc.
" (*) changed the name ThisMark to CurrentMark
" (*) added SearchCurrentMark and re-used raw map (instead of Vim function) to
"     implement * and #
"
" 14th Sep 2005, Luc Hermitte: modifications done on v1.1.4
" (*) anti-reinclusion guards. They do not guard colors definitions in case
"     this script must be reloaded after .gvimrc
" (*) Protection against disabled |line-continuation|s.
" (*) Script-local functions
" (*) Default keybindings
" (*) \r for visual mode
" (*) uses <Leader> instead of "\"
" (*) do not mess with global variable g:w
" (*) regex simplified -> double quotes changed into simple quotes.
" (*) strpart(str, idx, 1) -> str[idx]
" (*) command :Mark
"     -> e.g. :Mark Mark.\{-}\ze(

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_mark') || (v:version == 701 && ! exists('*matchadd')) || (v:version < 702)
	finish
endif
let g:loaded_mark = 1

"- default highlightings ------------------------------------------------------
" You may define your own colors in your vimrc file, in the form as below:
highlight def MarkWord1  ctermbg=Cyan     ctermfg=Black  guibg=#8CCBEA    guifg=Black
highlight def MarkWord2  ctermbg=Green    ctermfg=Black  guibg=#A4E57E    guifg=Black
highlight def MarkWord3  ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
highlight def MarkWord4  ctermbg=Red      ctermfg=Black  guibg=#FF7272    guifg=Black
highlight def MarkWord5  ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black
highlight def MarkWord6  ctermbg=Blue     ctermfg=Black  guibg=#9999FF    guifg=Black

" Default highlighting for the special search type. 
" You can override this by defining / linking the 'SearchSpecialSearchType'
" highlight group before this script is sourced. 
highlight def link SearchSpecialSearchType MoreMsg


"- mappings -------------------------------------------------------------------
nnoremap <silent> <Plug>MarkSet   :<C-u>call mark#MarkCurrentWord()<CR>
vnoremap <silent> <Plug>MarkSet   <C-\><C-n>:call mark#DoMark(mark#GetVisualSelectionAsLiteralPattern())<CR>
nnoremap <silent> <Plug>MarkRegex :<C-u>call mark#MarkRegex('')<CR>
vnoremap <silent> <Plug>MarkRegex <C-\><C-n>:call mark#MarkRegex(mark#GetVisualSelectionAsRegexp())<CR>
nnoremap <silent> <Plug>MarkClear :<C-u>call mark#DoMark(mark#CurrentMark()[0])<CR>
nnoremap <silent> <Plug>MarkAllClear :<C-u>call mark#DoMark()<CR>

nnoremap <silent> <Plug>MarkSearchCurrentNext :<C-u>call mark#SearchCurrentMark(0)<CR>
nnoremap <silent> <Plug>MarkSearchCurrentPrev :<C-u>call mark#SearchCurrentMark(1)<CR>
nnoremap <silent> <Plug>MarkSearchAnyNext     :<C-u>call mark#SearchAnyMark(0)<CR>
nnoremap <silent> <Plug>MarkSearchAnyPrev     :<C-u>call mark#SearchAnyMark(1)<CR>
nnoremap <silent> <Plug>MarkSearchNext        :<C-u>if !mark#SearchNext(0)<Bar>execute 'normal! *zv'<Bar>endif<CR>
nnoremap <silent> <Plug>MarkSearchPrev        :<C-u>if !mark#SearchNext(1)<Bar>execute 'normal! #zv'<Bar>endif<CR>
" When typed, [*#nN] open the fold at the search result, but inside a mapping or
" :normal this must be done explicitly via 'zv'. 


if !hasmapto('<Plug>MarkSet', 'n')
	nmap <unique> <silent> <Leader>m <Plug>MarkSet
endif
if !hasmapto('<Plug>MarkSet', 'v')
	vmap <unique> <silent> <Leader>m <Plug>MarkSet
endif
if !hasmapto('<Plug>MarkRegex', 'n')
	nmap <unique> <silent> <Leader>r <Plug>MarkRegex
endif
if !hasmapto('<Plug>MarkRegex', 'v')
	vmap <unique> <silent> <Leader>r <Plug>MarkRegex
endif
if !hasmapto('<Plug>MarkClear', 'n')
	nmap <unique> <silent> <Leader>n <Plug>MarkClear
endif
" No default mapping for <Plug>MarkAllClear. 

if !hasmapto('<Plug>MarkSearchCurrentNext', 'n')
	nmap <unique> <silent> <Leader>* <Plug>MarkSearchCurrentNext
endif
if !hasmapto('<Plug>MarkSearchCurrentPrev', 'n')
	nmap <unique> <silent> <Leader># <Plug>MarkSearchCurrentPrev
endif
if !hasmapto('<Plug>MarkSearchAnyNext', 'n')
	nmap <unique> <silent> <Leader>/ <Plug>MarkSearchAnyNext
endif
if !hasmapto('<Plug>MarkSearchAnyPrev', 'n')
	nmap <unique> <silent> <Leader>? <Plug>MarkSearchAnyPrev
endif
if !hasmapto('<Plug>MarkSearchNext', 'n')
	nmap <unique> <silent> * <Plug>MarkSearchNext
endif
if !hasmapto('<Plug>MarkSearchPrev', 'n')
	nmap <unique> <silent> # <Plug>MarkSearchPrev
endif


"- commands -------------------------------------------------------------------
command! -nargs=? Mark call mark#DoMark(<f-args>)

" vim: ts=2 sw=2
doc/mark.txt	[[[1
268
*mark.txt*              Highlight several words in different colors simultaneously. 

			    MARK    by Ingo Karkat
		       (original version by Yuheng Xie)
								    *mark.vim*
description			|mark-description|
usage	    			|mark-usage|
installation   			|mark-installation|
configuration  			|mark-configuration|
integration			|mark-integration|
limitations			|mark-limitations|
known problems			|mark-known-problems|
todo				|mark-todo|
history				|mark-history|

==============================================================================
DESCRIPTION						    *mark-description*

This script adds mappings and a :Mark command to highlight several words in
different colors simultaneously, similar to the built-in 'hlsearch'
highlighting of search results and the * |star| command. For example, when you
are browsing a big program file, you could highlight multiple identifiers in
parallel. This will make it easier to trace the source code.

This is a continuation of vimscript #1238 by Yuheng Xie, who apparently
doesn't maintain his original version anymore and cannot be reached via the
email address in his profile. This script offers the following advantages over
the original:
- Much faster, all colored words can now be highlighted, no more clashes with
  syntax highlighting (due to use of matchadd()). 
- Many bug fixes. 
- Jumps behave like the built-in search, including wrap and error messages. 
- Like the built-in commands, jumps take an optional [count] to quickly skip
  over some marks. 

RELATED WORKS *
- MultipleSearch (vimscript #479) can highlight in a single window and in all
  buffers, but still relies on the :syntax highlighting method, which is
  slower and less reliable. 
- http://vim.wikia.com/wiki/Highlight_multiple_words offers control over the
  color used by mapping the 1-9 keys on the numeric keypad, persistence, and
  highlights only a single window. 

==============================================================================
USAGE								  *mark-usage*

HIGHLIGHTING 						   *mark-highlighting*

<Leader>m		Mark or unmark the word under the cursor, similar to
			the |star| command. 
{Visual}<Leader>m	Mark or unmark the visual selection. 
<Leader>r		Manually input a regular expression to highlight. 
{Visual}<Leader>r	(Based on the visual selection.) 
			In accordance with the built-in |star| command,
			all these mappings use 'ignorecase', but not
			'smartcase'. 
<Leader>n		Clear the mark under the cursor / all marks. 
								       *:Mark*
:Mark {pattern}		Mark or unmark {pattern}. 
			For implementation reasons, {pattern} cannot use the
			'smartcase' setting, only 'ignorecase'. 
:Mark			Clear all marks. 


SEARCHING						      *mark-searching*

[count]*         [count]#
[count]<Leader>* [count]<Leader>#
[count]<Leader>/ [count]<Leader>?
			Use these six keys to jump to the [count]'th next /
			previous occurrence of a mark. 
			You could also use Vim's / and ? to search, since the
			mark patterns are (optionally, see configuration)
			added to the search history, too. 

            Cursor over mark                    Cursor not over mark
 ---------------------------------------------------------------------------
  <Leader>* Jump to the next occurrence of      Jump to the next occurrence of
            current mark, and remember it       "last mark". 
            as "last mark". 

  <Leader>/ Jump to the next occurrence of      Same as left. 
            ANY mark. 

   *        If <Leader>* is the most recently   Do Vim's original * command. 
            used, do a <Leader>*; otherwise
            (<Leader>/ is the most recently
            used), do a <Leader>/. 

			Note: When the cursor is on a mark, the backwards
			search does not jump to the beginning of the current
			mark (like the built-in search), but to the previous
			mark. The entire mark text is treated as one entity. 

			You can use Vim's |jumplist| to go back to previous
			mark matches and the position before a mark search. 

==============================================================================
INSTALLATION						   *mark-installation*

This script is packaged as a|vimball|. If you have the "gunzip" decompressor
in your PATH, simply edit the *.vba.gz package in Vim; otherwise, decompress
the archive first, e.g. using WinZip. Inside Vim, install by sourcing the
vimball or via the|:UseVimball|command. >
    vim mark.vba.gz
    :so %
To uninstall, use the|:RmVimball|command. 

DEPENDENCIES						   *mark-dependencies*

- Requires Vim 7.1 with "matchadd()", or Vim 7.2 or higher. 

==============================================================================
CONFIGURATION						  *mark-configuration*

You may define your own colors or more than the default 6 highlightings in
your vimrc file (or anywhere before this plugin is sourced), in the following
form (where N = 1..): >
    highlight MarkWordN ctermbg=Cyan ctermfg=Black guibg=#8CCBEA guifg=Black
<
The search type highlighting (in the search message) can be changed via: >
    highlight link SearchSpecialSearchType MoreMsg
<
By default, any marked words are also added to the search (/) and input (@)
history; if you don't want that, remove the corresponding symbols from: >
    let g:mwHistAdd = "/@"
<
You can use different mappings by mapping to the <Plug>Mark... mappings before
this plugin is sourced. To remove the default overriding of * and #, use: >
    nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
    nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
<
==============================================================================
INTEGRATION						    *mark-integration*

==============================================================================
LIMITATIONS						    *mark-limitations*

- If the 'ignorecase' setting is changed, there will be discrepancies between
  the highlighted marks and subsequent jumps to marks. 
- If {pattern} in a :Mark command contains atoms that change the semantics of
  the entire (|/\c|, |/\C|) or following (|/\v|,|/\V|, |/\M|) regular
  expression, there may be discrepancies between the highlighted marks and
  subsequent jumps to marks.  

KNOWN PROBLEMS						 *mark-known-problems*

TODO								   *mark-todo*

IDEAS								  *mark-ideas*

Taken from an alternative implementation at
http://vim.wikia.com/wiki/Highlight_multiple_words: 
- Allow to specify the highlight group number via :Mark [n] {regexp}
- Use keys 1-9 on the numeric keypad to toggle a highlight group number. 
- Persist the patterns in a uppercase global variable across Vim sessions.
  (Request from Mun Johl, 16-Apr-2010.) 
  Can be somewhat emulated by placing something like this in |vimrc|: >
    runtime plugin/mark.vim
    Mark foo
    Mark bar
< or defining a custom command a la: >
    command -bar MyMarks execute "Mark foo" | execute "Mark bar"

==============================================================================
HISTORY								*mark-history*

2.4.0	13-Jul-2010
- ENH: The MarkSearch mappings (<Leader>[*#/?]) add the original cursor
  position to the jump list, like the built-in [/?*#nN] commands. This allows
  to use the regular jump commands for mark matches, like with regular search
  matches. 

2.3.3	19-Feb-2010
- BUG: Clearing of an accidental zero-width match (e.g. via :Mark \zs) results
  in endless loop. Thanks to Andy Wokula for the patch. 

2.3.2	17-Nov-2009
- BUG: Creation of literal pattern via '\V' in {Visual}<Leader>m mapping
  collided with individual escaping done in <Leader>m mapping so that an
  escaped '\*' would be interpreted as a multi item when both modes are used
  for marking. Thanks to Andy Wokula for the patch. 

2.3.1	06-Jul-2009
- Now working correctly when 'smartcase' is set. All mappings and the :Mark
  command use 'ignorecase', but not 'smartcase'. 

2.3.0	04-Jul-2009
- All jump commands now take an optional [count], so you can quickly skip over
  some marks, as with the built-in */# and n/N commands. For this, the entire
  core search algorithm has been rewritten. The script's logic has been
  simplified through the use of Vim 7 features like Lists. 
- Now also printing a Vim-alike search error message when 'nowrapscan' is set. 

2.2.0	02-Jul-2009
- Split off functions into autoload script. 
- Initialization of global variables and autocommands is now done lazily on
  the first use, not during loading of the plugin. This reduces Vim startup
  time and footprint as long as the functionality isn't yet used. 
- Split off documentation into separate help file. Now packaging as VimBall.


2.1.0	06-Jun-2009
- Replaced highlighting via :syntax with matchadd() / matchdelete(). This
  requires Vim 7.2 / 7.1 with patches. This method is faster, there are no
  more clashes with syntax highlighting (:match always has preference), and
  the background highlighting does not disappear under 'cursorline'. 
- Using winrestcmd() to fix effects of :windo: By entering a window, its
  height is potentially increased from 0 to 1. 
- Handling multiple tabs by calling s:UpdateScope() on the TabEnter event. 

2.0.0	01-Jun-2009
- Now using Vim List for g:mwWord and thus requiring Vim 7. g:mwCycle is now
  zero-based, but the syntax groups "MarkWordx" are still one-based. 
- Factored :syntax operations out of s:DoMark() and s:UpdateMark() so that
  they can all be done in a single :windo. 
- Normal mode <Plug>MarkSet now has the same semantics as its visual mode
  cousin: If the cursor is on an existing mark, the mark is removed.
  Beforehand, one could only remove a visually selected mark via again
  selecting it. Now, one simply can invoke the mapping when on such a mark. 

1.6.1	31-May-2009
Publication of improved version by Ingo Karkat. 
- Now prepending search type ("any-mark", "same-mark", "new-mark") for better
  identification. 
- Retired the algorithm in s:PrevWord in favor of simply using <cword>, which
  makes mark.vim work like the * command. At the end of a line, non-keyword
  characters may now be marked; the previous algorithm preferred any preceding
  word. 
- BF: If 'iskeyword' contains characters that have a special meaning in a
  regexp (e.g. [.*]), these are now escaped properly. 
- Highlighting can now actually be overridden in the vimrc (anywhere _before_
  sourcing this script) by using ':hi def'. 
- Added missing setter for re-inclusion guard. 

1.5.0	01-Sep-2008
Bug fixes and enhancements by Ingo Karkat. 
- Added <Plug>MarkAllClear (without a default mapping), which clears all
  marks, even when the cursor is on a mark.
- Added <Plug>... mappings for hard-coded \*, \#, \/, \?, * and #, to allow
  re-mapping and disabling. Beforehand, there were some <Plug>... mappings
  and hard-coded ones; now, everything can be customized.
- BF: Using :autocmd without <bang> to avoid removing _all_ autocmds for the
  BufWinEnter event. (Using a custom :augroup would be even better.)
- BF: Explicitly defining s:current_mark_position; some execution paths left
  it undefined, causing errors.
- ENH: Make the match according to the 'ignorecase' setting, like the star
  command.
- ENH: The jumps to the next/prev occurrence now print 'search hit BOTTOM,
  continuing at TOP" and "Pattern not found:..." messages, like the * and n/N
  Vim search commands.
- ENH: Jumps now open folds if the occurrence is inside a closed fold, just
  like n/N do. 

1.1.8-g	25-Apr-2008
Last version published by Yuheng Xie on vim.org. 

1.1.2	22-Mar-2005
Initial version published by Yuheng Xie on vim.org. 

==============================================================================
Copyright: (C) 2005-2008 by Yuheng Xie
           (C) 2008-2010 by Ingo Karkat
The VIM LICENSE applies to this script; see|copyright|. 

Maintainer:	Ingo Karkat <ingo@karkat.de>
==============================================================================
 vim:tw=78:ts=8:ft=help:norl:
