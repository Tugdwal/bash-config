" Version 0.1.0

if !exists('s:loaded')
    let s:loaded = 1

source $HOME/.vim/tugdwal/Property.vim

let s:Parameter = {'m_name': NewProperty('')}

" Constructor

function! NewParameter(name)
    return s:Parameter.clone().setName(a:name)
endfunction

" Getter

function! s:Parameter.getName() dict
    return self.m_name
endfunction

function! s:Parameter.toString(save, index) dict
    if a:index && !a:save
        return '[' . ((a:save && self.getName().getValue()[0] == '%') ? '%' . self.getName().getValue() : '' . self.getName().getValue()) . ']'
    else
        return (a:save && self.getName().getValue()[0] == '%') ? '%' . self.getName().getValue() : '' . self.getName().getValue()
    endif
endfunction

" Setter

function! s:Parameter.setName(name) dict
    call self.getName().setValue(a:name)
    return self
endfunction

" Functions

function! s:Parameter.clone() dict
    return deepcopy(self)
endfunction

function! s:Parameter.equals(value) dict
    return self.getName().equals(a:value)
endfunction

endif

