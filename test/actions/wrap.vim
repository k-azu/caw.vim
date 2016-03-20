scriptencoding utf-8

let s:suite = themis#suite('actions.wrap')
let s:assert = themis#helper('assert')

let s:NORMAL_MODE_CONTEXT = {
\   'mode': 'n',
\   'visualmode': '',
\   'firstline': 1,
\   'lastline': 1
\}

function! s:suite.before() abort
    " Load filetype=c comment strings.
    " setlocal filetype=c    " XXX: Why this isn't working?
    runtime! after/ftplugin/c/caw.vim
endfunction

function! s:suite.before_each() abort
    let s:wrap = caw#new('actions.wrap')
endfunction

function! s:suite.after_each() abort
    call vmock#verify()
    call vmock#clear()
    call caw#__clear_context__()
endfunction


function! s:suite.comment() abort
    " vmock
    call vmock#mock('caw#getline').return('printf("hello\n");')
    call vmock#mock('caw#setline').with(1, '/* printf("hello\n"); */')

    " context
    call caw#__set_context__(deepcopy(s:NORMAL_MODE_CONTEXT))

    call s:assert.equals(b:caw_wrap_oneline_comment, ['/*', '*/'])
    call s:wrap.comment()
endfunction

function! s:suite.comment_indent() abort
    " vmock
    call vmock#mock('caw#getline').return('  printf("hello\n");')
    call vmock#mock('caw#setline').with(1, '  /* printf("hello\n"); */')

    " context
    call caw#__set_context__(deepcopy(s:NORMAL_MODE_CONTEXT))

    call s:assert.equals(b:caw_wrap_oneline_comment, ['/*', '*/'])
    call s:wrap.comment()
endfunction

function! s:suite.uncomment() abort
    " vmock
    call vmock#mock('caw#getline').return('/* printf("hello\n"); */')
    call vmock#mock('caw#setline').with(1, 'printf("hello\n");')

    " context
    call caw#__set_context__(deepcopy(s:NORMAL_MODE_CONTEXT))

    call s:assert.equals(b:caw_wrap_oneline_comment, ['/*', '*/'])
    call s:wrap.uncomment()
endfunction

function! s:suite.uncomment_indent() abort
    " vmock
    call vmock#mock('caw#getline').return('  /* printf("hello\n"); */')
    call vmock#mock('caw#setline').with(1, '  printf("hello\n");')

    " context
    call caw#__set_context__(deepcopy(s:NORMAL_MODE_CONTEXT))

    call s:assert.equals(b:caw_wrap_oneline_comment, ['/*', '*/'])
    call s:wrap.uncomment()
endfunction

function! s:suite.uncomment_no_spaces() abort
    " vmock
    call vmock#mock('caw#getline').return('  /*printf("hello\n");*/')
    call vmock#mock('caw#setline').with(1, '  printf("hello\n");')

    " context
    call caw#__set_context__(deepcopy(s:NORMAL_MODE_CONTEXT))

    call s:assert.equals(b:caw_wrap_oneline_comment, ['/*', '*/'])
    call s:wrap.uncomment()
endfunction
