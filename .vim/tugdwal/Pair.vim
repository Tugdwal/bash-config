" Version 0.1.0

if !exists('s:loaded')
    let s:loaded = 1

source $HOME/.vim/tugdwal/Property.vim

let s:Pair = {'m_first': NewProperty(''), 'm_second': NewProperty('')}

" Constructor

function! NewPair(first, second)
    return s:Pair.clone().setFirst(a:first).setSecond(a:second)
endfunction

" Getter

function! s:Pair.getFirst() dict
    return self.m_first.getValue()
endfunction

function! s:Pair.getSecond() dict
    return self.m_second.getValue()
endfunction

" Setter

function! s:Pair.setFirst(value) dict
    call self.m_first.setValue(a:value)
    return self
endfunction

function! s:Pair.setSecond(value) dict
    call self.m_second.setValue(a:value)
    return self
endfunction

function! s:Pair.setPair(pair) dict
    call self.m_first.setValue(a:pair.getFirst())
    call self.m_second.setValue(a:pair.getSecond())
    return self
endfunction

" Functions

function! s:Pair.clone() dict
    return deepcopy(self)
endfunction

function! s:Pair.equals(first, second)
    return self.getFirst() == a:first && self.getSecond() == a:second
endfunction

function! s:Pair.firstType() dict
    return type(self.getFirst())
endfunction

function! s:Pair.secondType() dict
    return type(self.getSecond())
endfunction

endif

