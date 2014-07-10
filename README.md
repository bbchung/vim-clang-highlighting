*clighter.txt*	Plugin for c-family semantic source code highlighting
*clighter*

Author: bbchung (afafaf4@gmail.com)
For Vim version 7.3 and above
Last change: 2014 July 10

==============================================================================
CONTENTS                                                  *clighter-contents*
1. Intro 			|clighter-intro|
2. Clighter on the internet	|clighter-internet|
3. Requirements			|clighter-requirements|
4. Options 			|clighter-options|
5. Customize Colors 		|clighter-colors|
6. FAQ				|clighter-faq|

==============================================================================
						*clighter-intro*
1. Intro~
Clighter(Clang Highlighter) is a c-family semantic highlighting plugin for
Vim based on Clang. This plugin use libclang to enhance c-family source code
highlighting from Vim builtin syntax highlighting to semantic highlighting.
Clighter doesn't disable the builtin syntax highlighting, it just "append"
the semantic highlighting into the word.  

Clighter provides the following features:

    * Autumatically do semantic highlighting for c-family source code.
    * Automatically mark all words that are same as the word under cursor
    * Options to customize the colors

==============================================================================
						*clighter-internet*
2. Clighter on the internet~

The Github repository is at:
>
	https://github.com/bbchung/clighter
<
==============================================================================
						*clighter-requirements*
3. Requirements~

The clighter plugin requires the following:

    * Vim version 7.3 and above
    * libclang

Clighter currently works only at linux platform, others have not been test.

==============================================================================
						*clighter-options*
4. Options~

|'g:enable_clighter'|			Enable the Clighter
|'g:clighter_cursor_toggle_key'|	Keymap for toggling search highlighting
|'g:clighter_clang_options'|		The Compile options for Clang
|'g:clighter_libclang_path'|		The path of the libclang

						*'enable_clighter'*
g:enable_clighter~
Default: 1
If enabled, Clighter will start with Vim, you can disable Clighter by set
g:enable_clighter to 0
>
	let g:enable_clighter = 0
<

						*'clighter_cursor_toggle_key'*
g:clighter_cursor_toggle_key~
Default: '<F3>'
The hotkey to toggle cursor highlighting function.
>
	let g:clighter_cursor_toggle_key = '<F3>'
<
						*'clighter_clang_options'*
g:clighter_clang_options~
Default: []
The compiler options for libclang. Sometimes Clighter doesn't do corret
highlighting cause Clang can't parse the source code, then you need tell Clang
how to parse it. You can set the compiler options to the list in
g:clighter_clang_options
>
	let g:clighter_clang_options = ['-std=c++', '-DLinux']
<
						*'clighter_libclang_path'*
g:clighter_libclang_path~
Default: undefine
Clighter use default path to find libclang, if your libclang is not in
default path, tell Clighter by this option
>
	let g:clighter_libclang_path = '/usr/lib/libclang.so'
<
==============================================================================
						*clighter-colors*
5. Customize Colors~

Clighter defines the following syntax group corresponding to CursorKing of

MacroInstantiation~
Default: link to Macro

TypeRef~
Default: link to Type

StructDecl~
Default: link to Type

ClassDecl~
Default: link to Type

EnumDecl~
Default: link to Type

EnumConstantDecl~
Default: link to Identifier

eg:
>
	hi TypeRef term=NONE cterm=NONE ctermbg=232 ctermfg=255 gui=NONE
	hi ClassDecl term=NONE cterm=NONE ctermbg=255 ctermfg=232 gui=NONE
<

==============================================================================
						*clighter-faq*
6. Frequently Asked Questions~

Q. The clighter plugin doesn't work.
A. Vim version 7.3 or above is need, and make sure libclang is installed
correctly and set g:clighter_libclang_path if need.

Q. Highlighing is not quick-response
A. Clighter use CursorHold event to update the current window highlighting,
you can set updatetime smaller. Remember that other plugins may chagne the
updatetime
>
	set updatetime=1200
<

==============================================================================

vim:tw=78:ts=8:noet:ft=help: