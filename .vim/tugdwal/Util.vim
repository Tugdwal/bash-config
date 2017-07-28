" Version 0.1.0

if !exists('s:loaded')
    let s:loaded = 1

function! IsNumber(str)
    return !(a:str =~ '\D')
endfunction

endif
