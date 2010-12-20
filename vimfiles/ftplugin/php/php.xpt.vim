XPTemplate priority=lang

let s:f = g:XPTfuncs()

XPTvar $TRUE          true
XPTvar $FALSE         false
XPTvar $NULL          null
XPTvar $UNDEFINED     null

XPTvar $VOID_LINE      /* void */;
XPTvar $CURSOR_PH      /* cursor */

XPTvar $BRif          ' '
XPTvar $BRel          \n
XPTvar $BRloop        ' '
XPTvar $BRstc         ' '
XPTvar $BRfun         ' '

XPTinclude
      \ _common/common

XPTvar $CL    /*
XPTvar $CM    *
XPTvar $CR    */
XPTinclude
      \ _comment/doubleSign

XPTvar $VAR_PRE   $
XPTvar $FOR_SCOPE
XPTinclude
      \ _loops/for

XPTinclude
      \ _condition/c.like
      \ _loops/c.while.like

XPTembed
      \ html/html
      \ html/php*



if exists( 'php_noShortTags' )
    XPTvar $PHP_TAG php
else
    XPTvar $PHP_TAG
endif

" ========================= Function and Variables =============================

" ================================= XPTs ===================================

XPT html " <?$PHP_TAG ... ?>
?>`html^<?`$PHP_TAG^


XPT foreach " foreach (.. as ..) {..}
foreach ($`var^ as `container^)`$BRloop^{
    `cursor^
}


XPT fun " function ..( .. ) {..}
XSET params=Void()
XSET params|post=EchoIfEq('  ', '')
function `funName^(` `params` ^)
{
    `cursor^
}


XPT class " class .. { .. }
class `className^
{
    function __construct( `args^ )
    {
        `cursor^
    }
}


XPT interface " interface .. { .. }
interface `interfaceName^`$BRfun^{
    `cursor^
}


XPT inc " include '...'
include '`fileName^';
XPT inc1 " include_once '...'
include_once '`fileName^';
XPT req " require '...'
require '`fileName^';
XPT req1 " require_once '...'
/**
 * @see `fileName^
 */
require_once '`fileName^';

# Class - post doc
XPT doc_cp " /** PHPDOC_copyright */
/**
 * `undocumented class^
 *
 * @category `default^
 * @package `className^
 * @copyright Copyright (c) 2010-2012 Seven color. (http://www.7color.org)
 * @license http://www.opensource.org/licenses/bsd-license.php  New BSD License
 * @version $Id `fileName^.php `strftime('%Y-%m-%d %H:%M:%S')`^Z 7color $
 */`cursor^
# Class Variable - post doc
XPT doc_vp " /** PHPDOC_Class_Variable_Post */
/**
 * `undocumented class variable^
 *
 * @var `string^
 */`cursor^
# Class Variable
XPT doc_v " /** PHPDOC_Class_Variable */
/**
 * `undocumented class variable^
 *
 * @var `string^
 */
`varType^ $`varName^;`cursor^
# Class
XPT doc_c " /** PHPDOC_Class */
/**
 * `undocumented class^
 *
 * @category `default^
 * @package `className^
 * @copyright Copyright (c) 2010-2012 Seven color. (http://www.7color.org)
 * @license http://www.opensource.org/licenses/bsd-license.php  New BSD License
 */
class `className^
{
  `cursor^
}
# Constant Definition - post doc
XPT doc_dp " /** PHPDOC_Constant_Definition_Post */
/**
 * `undocumented constant^
 */`cursor^
# Constant Definition
XPT doc_d " /** PHPDOC_Constant_Definition */
/**
 * `undocumented constant^
 */
define(`varName^, `varValue^);`cursor^
# Function - post doc
XPT doc_fp " /** PHPDOC_Function_Post */
/**
 * `undocumented function^
 *
 * @param `mixed^ `argName^ `argDescript^
 * @return `void^
 */`cursor^
# Function signature
XPT doc_s " /** PHPDOC_Function_Signature **/
/**
 * `undocumented function^
 *
 * @param `mixed^ `argName^ `argDescript^
 * @return `void^
 */
`funType^function `funName^(`funArg^);`cursor^
# Function
XPT doc_f " /** PHPDOC_Function */
/**
 * `undocumented function^
 *
 * @param `mixed^ `argName^ `argDescript^
 * @return `void^
 */
`funType^function `funName^(`funArg^)
{
  `cursor^
}
# Header
XPT doc_h " /** PHPDOC_Header */
/**
 * `Project name^
 *
 * `classDescript^
 * 
 * @category `default^
 * @package `className^
 * @copyright Copyright (c) 2010-2012 Seven color. (http://www.7color.org)
 * @license http://www.opensource.org/licenses/bsd-license.php  New BSD License
 * @version $Id `fileName^.php `strftime('%Y-%m-%d %H:%M:%S')`^Z 7color $
 */`cursor^
# Interface
XPT doc_i " /** PHPDOC_Interface */
/**
 * `undocumented class^
 *
 * @category `default^
 * @package `className^
 * @copyright Copyright (c) 2010-2012 Seven color. (http://www.7color.org)
 * @license http://www.opensource.org/licenses/bsd-license.php  New BSD License
 * @version $Id `fileName^.php `strftime('%Y-%m-%d %H:%M:%S')`^Z 7color $
 */
interface `interfaceName^
{
  `cursor^
}


" ================================= Wrapper ===================================
