" Version 0.1.0

if !exists('s:loaded')
    let s:loaded = 1

let s:Property = {'m_value': ''}

" Constructor

function! NewProperty(value)
    return s:Property.clone().setValue(a:value)
endfunction

" Getter

function! s:Property.getValue() dict
    return self.m_value
endfunction

" Setter

function! s:Property.setValue(value) dict
    let self.m_value = a:value
    return self
endfunction

" Functions

function! s:Property.clone() dict
    return deepcopy(self)
endfunction

function! s:Property.equals(value)
    return self.getValue() == a:value
endfunction

function! s:Property.type() dict
    return type(self.getValue())
endfunction

endif

