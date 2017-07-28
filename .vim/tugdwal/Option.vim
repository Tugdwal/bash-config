" Version 0.1.0

if !exists('s:loaded')
    let s:loaded = 1

source $HOME/.vim/tugdwal/Property.vim

let s:Option = {'m_name': NewProperty(''), 'm_parameter': NewProperty('')}

" Constructor

function! NewOption(name, parameter)
    return s:Option.clone().setName(a:name).setParameter(a:parameter)
endfunction

" Getter

function! s:Option.getName() dict
    return self.m_name
endfunction

function! s:Option.getParameter() dict
    return self.m_parameter
endfunction

function! s:Option.toString(save, index) dict
    if a:save
        return self.getParameter().equals('') ? '-' . self.getName().getValue() : '-' . self.getName().getValue() . ' %' . self.getParameter().getValue()
    elseif a:index
        return self.getParameter().equals('') ? '[-' . self.getName().getValue() . ']' : '[-' . self.getName().getValue() . ' ' . self.getParameter().getValue() . ']'
    else
        return self.getParameter().equals('') ? '-' . self.getName().getValue() : '-' . self.getName().getValue() . ' ' . self.getParameter().getValue()
    endif
endfunction

" Setter

function! s:Option.setName(name) dict
    call self.getName().setValue(a:name)
    return self
endfunction

function! s:Option.setParameter(parameter) dict
    call self.getParameter().setValue(a:parameter)
    return self
endfunction

" Functions

function! s:Option.clone() dict
    return deepcopy(self)
endfunction

function! s:Option.equals(value) dict
    return self.getName().equals(a:value) || self.getName().equals(a:value[1:])
endfunction

endif

