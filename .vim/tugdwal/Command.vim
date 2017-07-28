" Version 0.1.0

if !exists('s:loaded')
    let s:loaded = 1

source $HOME/.vim/tugdwal/Option.vim
source $HOME/.vim/tugdwal/Parameter.vim
source $HOME/.vim/tugdwal/Option.vim

let s:Command = {'m_name': NewProperty(''), 'm_arguments': []}

" Constructor

function! NewCommand(name, ...)
    return s:Command.clone().setName(a:name).addArguments(a:000)
endfunction

" Getter

function! s:Command.getName() dict
    return self.m_name
endfunction

function! s:Command.getArguments() dict
    return self.m_arguments
endfunction

function! s:Command.getNumberOfArguments() dict
    return len(self.getArguments())
endfunction

function! s:Command.getArgument(id) dict
    let l:index = self.indexOfArgument(a:id)
    if l:index != -1
        return self.getArguments()[a:id]
    endif
    return {}
endfunction

function! s:Command.toString(save, index) dict
    let l:command = [self.getName().getValue()]
    if a:index && !a:save
        let l:index = 0
        for l:argument in self.getArguments()
            call add(l:command, '[' . l:index . ']' . l:argument.toString(a:save, a:index))
            let l:index += 1
        endfor
    else
        for l:argument in self.getArguments()
            call add(l:command, l:argument.toString(a:save, a:index))
        endfor
    endif
    return join(l:command)
endfunction

" Setter

function! s:Command.addArguments(arguments) dict
    call extend(self.getArguments(), self.parseArguments(a:arguments))
    return self
endfunction

function! s:Command.insertArguments(at, arguments) dict
    if IsNumber(a:at)
        let l:index = str2nr(a:at)
        if l:index < self.getNumberOfArguments()
            if l:index == 0
                let self.m_arguments = self.parseArguments(a:arguments) + self.getArguments()
            else
                let self.m_arguments = self.getArguments()[:l:index-1] + self.parseArguments(a:arguments) + self.getArguments()[l:index:]
            endif
        endif
    endif
    return self
endfunction

function! s:Command.setName(value) dict
    call self.getName().setValue(a:value)
    return self
endfunction

function! s:Command.setArguments(arguments) dict
    let self.m_arguments = self.parseArguments(a:arguments)
    return self
endfunction

function! s:Command.deleteArguments(...) dict
    for l:id in a:000
        let l:index = self.indexOfArgument(l:id)
        if l:index != -1
            cal remove(self.getArguments(), l:index)
        endif
    endfor
    return self
endfunction

" Functions

function! s:Command.clone() dict
    return deepcopy(self)
endfunction

function! s:Command.equals(value) dict
    return self.getName().getValue() == a:value
endfunction

function! s:Command.resetArguments() dict
    let self.m_arguments = []
endfunction

function! s:Command.indexOfArgumentByName(name) dict
    let l:index = 0
    for l:argument in self.getArguments()
        if l:argument.equals(a:name)
            return l:index
        endif
        let l:index += 1
    endfor
    return -1
endfunction

function! s:Command.indexOfArgument(id) dict
    if type(a:id) == type(0)
        if a:id < self.getNumberOfArguments()
            return a:id
        endif
    elseif type(a:id) == type('')
        if len(a:id) > 0 && a:id[0] == '%'
            if len(a:id) > 1
                if a:id[1] == '%'
                    return self.indexOfArgumentByName(a:id[1:])
                else
                    if a:id[1:] + 0 < self.getNumberOfArguments()
                        return a:id[1:]
                    endif
                endif
            else
                return self.indexOfArgumentByName(a:id)
            endif
        else
            return self.indexOfArgumentByName(a:id)
        endif
    endif
    return -1
endfunction

function! s:Command.parseArguments(arguments) dict
    let l:arguments = []
    let l:option = ''
    for l:argument in a:arguments
        if len(l:argument) > 0
            if l:argument[0] == '-'
                if len(l:argument) > 1
                    if l:option != ''
                        call add(l:arguments, NewOption(l:option, ''))
                    endif
                    let l:option = l:argument[1:]
                endif
            else
                if l:option == ''
                    call add(l:arguments, NewParameter(l:argument))
                else
                    if l:argument[0] == '%'
                        if len(l:argument) > 1
                            if l:argument[1] == '%'
                                call add(l:arguments, NewOption(l:option, ''))
                                call add(l:arguments, NewParameter(l:argument[1:]))
                            else
                                call add(l:arguments, NewOption(l:option, l:argument[1:]))
                            endif
                        else
                            call add(l:arguments, NewOption(l:option, l:argument))
                        endif
                    else
                        call add(l:arguments, NewOption(l:option, ''))
                        call add(l:arguments, NewParameter(l:argument))
                    endif
                    let l:option = ''
                endif
            endif
        endif
    endfor
    if l:option != ''
        call add(l:arguments, NewOption(l:option, ''))
    endif
    return l:arguments
endfunction

endif

