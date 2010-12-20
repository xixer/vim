XPTemplate priority=personal


" containers
let s:f = g:XPTfuncs()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Variables =============================
XPTvar $CL    <!--
XPTvar $CM
XPTvar $CR      -->
XPTvar $DATE_FMT '%Y年%m月%d日 %H:%M'
XPTvar $DATE_CUSTOM_FMT '%Y年%m月%d日 - 日待办事项'

fun! s:f.tdate(...) "{{{
  return strftime( self.GetVar( '$DATE_CUSTOM_FMT' ) )
endfunction "}}}

call XPTdefineSnippet("Tdate", {}, "`tdate()^")
" ================================= Snippets ===================================
XPT title "%title ... = ... =
%title `title^
 = `title^ =
`cursor^

XPT dtitle "%title ... = ... =
%title `date^
 = `date^ =
`cursor^

XPT ttitle "%title ... = ... =
%title `tdate^
 = `tdate^ =
`cursor^

XPT h1 "  = ... =
= `cursor^ =

XPT h2 " == ... ==
== `cursor^ ==

XPT h3 " === ... ===
=== `cursor^ ===

XPT h4 " ==== ... ====
==== `cursor^ ====

XPT h5 " ===== ... =====
===== `cursor^ =====

XPT h6 " ====== ... ======
====== `cursor^ ======

XPT code " {{{...}}}
{{{class="brush: `js^"
  `cursor^
}}}

XPT pre "<pre>...</pre>
{{{
  `cursor^
}}}

XPT todo " * [X] ...
 * [`cursor^] `cursor^
