" Version 0.1.0

if !exists('s:loaded')
    let s:loaded = 1

source $HOME/.vim/tugdwal/Util.vim
source $HOME/.vim/tugdwal/Property.vim
source $HOME/.vim/tugdwal/Pair.vim
source $HOME/.vim/tugdwal/Command.vim

"let s:Vimvar = {'m_enabled': NewProperty(1), 'm_index': NewProperty(1), 'm_commands': [NewCommand('ls', '-l', '-r', '%%123'), NewCommand('gcc', 'hey', '-o', '%test', '-t', 'hi')]}
let s:Vimvar = {'m_enabled': NewProperty(1), 'm_index': NewProperty(0), 'm_commands': [], 'm_selected': NewPair(-1, {})}

" Constructor

function! NewVimvar()
    return s:Vimvar.clone()
endfunction

" Getter

function! s:Vimvar.getEnabled() dict
    return self.m_enabled
endfunction

function! s:Vimvar.getIndex() dict
    return self.m_index
endfunction

function! s:Vimvar.getCommands() dict
    return self.m_commands
endfunction

function! s:Vimvar.getNumberOfCommands() dict
    return len(self.getCommands())
endfunction

function! s:Vimvar.getCommand(id) dict
    let l:index = self.indexOfCommand(a:id)
    if l:index != -1
        return NewPair(l:index, self.getCommands()[l:index])
    endif
    return NewPair(-1, {})
endfunction

function! s:Vimvar.getSelected() dict
    return self.m_selected
endfunction

function! s:Vimvar.toStrings(save, index) dict
    let l:commands = []
    for l:command in self.getCommands()
        let l:commands += [l:command.toString(a:save, a:index)]
    endfor
    return l:commands
endfunction

function! s:Vimvar.toString(save, index, str) dict
    return join(self.toStrings(a:save, a:index), a:str)
endfunction

function! s:Vimvar.Enabled() dict
    return self.getEnabled().getValue()
endfunction

function! s:Vimvar.Index() dict
    return self.getIndex().getValue()
endfunction

function! s:Vimvar.Selected() dict
    if self.getSelected().getFirst() == -1
        return 'Selected command: ""'
    else
        return 'Selected command: "' . self.getSelected().getSecond().toString(0, 1) . '"'
    endif
endfunction

function! s:Vimvar.GetCommandLine() dict
    return self.toString(0, self.Index(), " \u2192 ")
endfunction

" Setter

function! s:Vimvar.setEnabled(value) dict
    call self.getEnabled().setValue(a:value)
    return self
endfunction

function! s:Vimvar.setIndex(value) dict
    call self.getIndex().setValue(a:value)
    return self
endfunction

function! s:Vimvar.setSelected(value) dict
    call self.getSelected.setPair(a:value)
    return self
endfunction

" Functions

function! s:Vimvar.ToggleStatus() dict
    call self.setEnabled(!self.Enabled())
    echo ''
    return self
endfunction

function! s:Vimvar.ToggleIndex() dict
    call self.setIndex(!self.Index())
    echo ''
    return self
endfunction

function! s:Vimvar.Reset()
    let self.m_commands = []
endfunction

function! s:Vimvar.ResetArguments(...)
    if a:0 > 0
        for l:id in a:000
            let l:command = self.getCommand(l:id)
            if !empty(l:command)
                call l:command.resetArguments()
            endif
        endfor
    else
        if self.getSelected().getFirst() != -1
            self.getSelected().getSecond().resetArguments()
        endif
    endif
    return self
endfunction

function! s:Vimvar.SelectCommand(id) dict
    let l:command = self.getCommand(a:id)
    if l:command.getFirst() != -1
        let self.m_selected = l:command
    endif
    return self
endfunction

function! s:Vimvar.DeselectCommand() dict
    let self.m_selected = NewPair(-1, {})
    return self
endfunction

function! s:Vimvar.AddCommand(name, ...) dict
    call add(self.getCommands(), call('NewCommand', [a:name] + a:000))
    return self
endfunction

function! s:Vimvar.AddArguments(id, ...) dict
    if a:id == "%"
        if self.getSelected().getFirst() != -1
            call self.getSelected().getSecond().addArguments(a:000)
        endif
    else
        let l:command = self.getCommand(a:id)
        if l:command.getFirst() != -1
            call l:command.getSecond().addArguments(a:000)
            let self.m_selected = l:command
        endif
    endif
    return self
endfunction

function! s:Vimvar.InsertCommand(id, name, ...) dict
    let l:index = self.indexOfCommand(a:id)
    if l:index != -1
        call insert(self.getCommands(), call('NewCommand', [a:name] + a:000), l:index)
    return self
endfunction

function! s:Vimvar.InsertArguments(id, at, ...) dict
    if a:id == "%"
        if self.getSelected().getFirst() != -1
            call self.getSelected().getSecond().insertArguments(a:at, a:000)
        endif
    else
        let l:command = self.getCommand(a:id)
        if l:command.getFirst() != -1
            call l:command.getSecond().insertArguments(a:at, a:000)
            let self.m_selected = l:command
        endif
    endif
    return self
endfunction

function! s:Vimvar.SetCommand(id, name, ...) dict
    let l:command = self.getCommand(a:id)
    if !empty(l:command)
        call l:command.setName(a:name).setArguments(a:000)
    endif
    return self
endfunction

function! s:Vimvar.SetName(id, name) dict
    if a:id == "%"
        if self.getSelected().getFirst() != -1
            call self.getSelected().getSecond().setName(a:name)
        endif
    else
        let l:command = self.getCommand(a:id)
        if l:command.getFirst() != -1
            call l:command.getSecond().setName(a:name)
            let self.m_selected = l:command
        endif
    endif
    return self
endfunction

function! s:Vimvar.SetArguments(id, ...) dict
    if a:id == "%"
        if self.getSelected().getFirst() != -1
            call self.getSelected().getSecond().setArguments(a:000)
        endif
    else
        let l:command = self.getCommand(a:id)
        if l:command.getFirst() != -1
            call l:command.getSecond().setArguments(a:000)
            let self.m_selected = l:command
        endif
    endif
    return self
endfunction

function! s:Vimvar.DeleteCommand(...) dict
    if a:0 > 0
        for l:id in a:000
            let l:index = self.indexOfCommand(l:id)
            if l:index != -1
                call remove(self.getCommands(), l:index)
            endif
        endfor
    elseif self.getSelected().getFirst() != -1
        call remove(self.getCommands(), self.getSelected().getFirst())
        let self.m_selected = NewPair(-1, {})
    endif
    return self
endfunction

function! s:Vimvar.DeleteArguments(id, ...) dict
    if a:id == "%"
        if self.getSelected().getFirst() != -1
            call self.getSelected().getSecond().deleteArguments(a:000)
        endif
    else
        let l:command = self.getCommand(a:id)
        if l:command.getFirst() != -1
            call l:command.getSecond().delArguments(a:000)
            let self.m_selected = l:command
        endif
    endif
    return self
endfunction

function! s:Vimvar.Execute() dict
    silent !clear
    redraw!
    echo system(self.toString(0, 0, ' && '))
    return self
endfunction

function! s:Vimvar.Save(...) dict
    let l:filename = a:0 > 0 ? a:1 : "$HOME/.vimvar"
    call writefile(self.toStrings(1, 0), expand(l:filename))
    return self
endfunction

function! s:Vimvar.Load(...) dict
    call self.Reset()
    let l:filename = a:0 > 0 ? a:1 : "$HOME/.vimvar"
    let l:filename = expand(l:filename)
    if filereadable(l:filename)
        let l:file = readfile(l:filename)
        for l:command in l:file
            call call(self.AddCommand, split(l:command), self)
        endfor
    endif
    return self
endfunction

" Utility

function! s:Vimvar.clone() dict
    return deepcopy(self)
endfunction

function! s:Vimvar.indexOfCommandByName(name) dict
    let l:index = 0
    for l:command in self.getCommands()
        if l:command.equals(a:name)
            return l:index
        endif
        let l:index += 1
    endfor
    return -1
endfunction

function! s:Vimvar.indexOfCommand(id) dict
    if type(a:id) == type(0)
        if a:id < self.getNumberOfCommands()
            return a:id
        endif
    elseif type(a:id) == type('')
        if len(a:id) > 0 && a:id[0] == '%'
            if len(a:id) > 1
                if a:id[1] == '%'
                    return self.indexOfCommandByName(a:id[1:])
                else
                    if IsNumber(a:id[1:]) && str2nr(a:id[1:]) < self.getNumberOfCommands()
                        return str2nr(a:id[1:])
                    endif
                endif
            else
                return self.indexOfCommandByName(a:id)
            endif
        else
            return self.indexOfCommandByName(a:id)
        endif
    endif
    return -1
endfunction

endif

