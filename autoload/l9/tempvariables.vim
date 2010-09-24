"=============================================================================
" Copyright (C) 2010 Takeshi NISHIDA
"
"=============================================================================
" LOAD GUARD {{{1

if !l9#guardScriptLoading(expand('<sfile>:p'), 702, l9#getVersion())
  finish
endif

" }}}1
"=============================================================================
" TEMPORARY VARIABLES {{{1

"
let s:varsMap = {}

" set temporary variables
function l9#tempvariables#set(group, name, value)
  if !exists('s:varsMap[a:group]')
    let s:varsMap[a:group] = {'vars': {}, 'active': 1}
  endif
  if !exists('s:varsMap[a:group].vars[a:name]')
    let s:varsMap[a:group].vars[a:name] = {'original': eval(a:name)}
  endif
  let s:varsMap[a:group].vars[a:name].temp = a:value
  if s:varsMap[a:group].active
    execute 'let ' . a:name . ' = a:value'
  endif
endfunction

" set temporary variables
function l9#tempvariables#setList(group, variables)
  for [name, value] in a:variables
    call l9#tempvariables#set(a:group, name, value)
    unlet value " to avoid E706
  endfor
endfunction

" swap temporary variables and original variables
function l9#tempvariables#swap(group)
  if s:varsMap[a:group].active
    let variables = map(copy(s:varsMap[a:group].vars), 'v:val.original')
  else
    let variables = map(copy(s:varsMap[a:group].vars), 'v:val.temp')
  endif
  for [name, value] in items(variables)
    execute 'let ' . name . ' = value'
    unlet value " to avoid E706
  endfor
  let s:varsMap[a:group].active = !s:varsMap[a:group].active
endfunction

" restore original variables and clean up.
function l9#tempvariables#end(group)
  if !exists('s:varsMap[a:group]')
    return
  endif
  if s:varsMap[a:group].active
    call l9#tempvariables#swap(a:group)
  endif
  unlet s:varsMap[a:group]
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker:

