if exists('g:loaded_vim_clang_highlight')
      finish
endif

if !exists('g:enable_clang_highlighting')
	let g:enable_clang_highlighting=1
endif

if g:enable_clang_highlighting == 1

if !exists ('g:key_toggle_srchhl')
    let g:key_toggle_srchhl = '<F3>'
endif

if !exists('g:clang_options')
    let g:clang_options=[]
endif

python << endpython
import vim
import sys
import clang.cindex
from threading import Thread

gTu=None # global translation unit

def start_parsing():
    t = Thread(target=do_parsing, args=(vim.eval('g:clang_options'),))
    t.start()

def do_parsing(options):
    global gTu
    if int(vim.eval('exists(\'g:libclang_path\')')) == 1:
        clang.cindex.Config.set_library_file(vim.eval("g:libclang_path"))

    clang.cindex.Config
    idx = clang.cindex.Index.create()
    gTu = idx.parse(vim.current.buffer.name, options, [(vim.current.buffer.name, "\n".join(vim.current.buffer))], options=clang.cindex.TranslationUnit.PARSE_DETAILED_PROCESSING_RECORD)

def vim_highlight(t, group):
	vim.command("call add(w:matched_list, matchadd('{0}', '\%{1}l\%>{2}c.\%<{3}c', -1))".format( group, t.location.line, t.location.column-1, t.location.column+len(t.spelling) + 1));

def try_highlighting():
    global gTu
    if gTu == None:
        return

    #for t in gTu.cursor.get_tokens(extent=clang.cindex.SourceRange(start=clang.cindex.SourceLocation(line=top), end=clang.cindex.SourceLocation(line=bottom))):
    file = clang.cindex.File.from_name(gTu, vim.current.buffer.name)
    top = clang.cindex.SourceLocation.from_position(gTu, file, int(vim.eval("line('w0')")), 1)
    bottom = clang.cindex.SourceLocation.from_position(gTu, file, int(vim.eval("line('w$')")), 1)
    range = clang.cindex.SourceRange.from_locations(top, bottom)

    tokens = gTu.get_tokens(extent=range)
    if len(list(tokens)) == 0:
        return

    vim.command('call s:clear_match()')
    for t in gTu.get_tokens(extent=range):
        if t.kind.value == 2:
            if t.cursor.kind == clang.cindex.CursorKind.MACRO_INSTANTIATION:
                vim_highlight(t, 'MacroInstantiation')
            elif t.cursor.kind == clang.cindex.CursorKind.STRUCT_DECL:
                vim_highlight(t, 'StructDecl')
            elif t.cursor.kind == clang.cindex.CursorKind.CLASS_DECL:
                vim_highlight(t, 'ClassDecl')
            elif t.cursor.kind == clang.cindex.CursorKind.ENUM_DECL:
                vim_highlight(t, 'EnumDecl')
            elif t.cursor.kind == clang.cindex.CursorKind.ENUM_CONSTANT_DECL:
                vim_highlight(t, 'EnumConstantDecl')
            elif t.cursor.kind == clang.cindex.CursorKind.TYPE_REF:
                vim_highlight(t, 'TypeRef')
endpython

fun! s:clear_match()
	for i in w:matched_list
		call matchdelete(i)
	endfor
	let w:matched_list=[]
endf

fun! s:start_parsing()
python << endpython
start_parsing()
endpython
endf

fun! s:parsing_and_highlighting()
python << endpython
start_parsing()
try_highlighting()
endpython
endf

fun! s:highlighting()
python << endpython
try_highlighting()
endpython
endf

fun! ToggleAutoHighlight()
    if exists('s:auto_highlight_on') && s:auto_highlight_on==1
        match none
        au! AutoHighlight
        let s:auto_highlight_on=0
    else
        augroup AutoHighlight
            au CursorHold * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
            au CursorMoved * match none
            "au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
        augroup END
        let s:auto_highlight_on=1
    endif
endf

execute "nmap <silent> ".g:key_toggle_srchhl. " :call ToggleAutoHighlight()<CR>"

hi link MacroInstantiation Macro
hi link TypeRef Type
hi link StructDecl Type
hi link ClassDecl Type
hi link EnumDecl Type
hi link EnumConstantDecl Identifier

augroup ClangHighlight
    au WinEnter *.[ch],*.[ch]pp,*.objc if !exists('w:matched_list') | let w:matched_list=[] | endif
    au CursorHold *.[ch],*.[ch]pp,*.objc call s:start_parsing()
    au CursorHold *.[ch],*.[ch]pp,*.objc call s:highlighting()
    au FileType c,cpp,objc call s:parsing_and_highlighting()
augroup END

endif

let g:loaded_vim_clang_highlight = 1
