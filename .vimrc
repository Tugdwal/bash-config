" Version 0.1.0

" ######################################## "
" >>                MENU                << "
" ######################################## "

" Press * to jump

" >>       MENU       << "
" >>     INCLUDES     << "
" >>   BASIC_CONFIG   << "
" >>    HIGHLIGHTS    << "
" >>      EVENTS      << "
" >>   ABBREVIATION   << "
" >>   KEYS_MAPPING   << "
" >>     COMMANDS     << "
" >>     VARIABLE     << "
" >>     FUNCTION     << "
" >>       TEST       << "

" ######################################## "
" >>              INCLUDES              << "
" ######################################## "

source $HOME/.vim/tugdwal/Util.vim
source $HOME/.vim/tugdwal/Vimvar.vim

" ######################################## "
"               BASIC_CONFIG               "
" ######################################## "

colorscheme elflord

set encoding=utf-8

set autoindent
set cursorline
set expandtab
set hlsearch
set laststatus=2
set list
set listchars=tab:→\ ,trail:°
set number
set relativenumber
set showcmd
set showmatch
set softtabstop=4
set shiftwidth=4
set smartindent
set smarttab
set tabstop=4
set visualbell
set wildmenu

"CHAR [¬]
"CHAR [◦]
"CHAR [▶]

" ######################################## "
" >>             HIGHLIGHTS             << "
" ######################################## "

highlight clear Cursorline
" highlight Cursorline cterm=underline ctermbg=None ctermfg=None gui=underline guibg=None guifg=None
highlight Cursorline cterm=underline ctermbg=NONE ctermfg=NONE gui=underline guibg=NONE guifg=NONE

highlight PreProc NONE
highlight NonText ctermfg=Cyan
highlight SpecialKey ctermfg=Cyan

highlight clear Conceal
highlight Conceal ctermbg=Black ctermfg=Cyan

highlight User1 ctermfg=Black ctermbg=White
highlight User2 ctermfg=White ctermbg=Black
highlight User3 ctermfg=Black ctermbg=Black
highlight User4 ctermfg=Black ctermbg=Cyan
highlight User5 ctermfg=Yellow ctermbg=Black
highlight User6 ctermfg=Red ctermbg=Black

"hi User7 ctermfg=White ctermbg=Black
"hi User8 ctermfg=White ctermbg=Black
"hi User9 ctermfg=White ctermbg=Black

"White Black Blue Green Cyan Red Magenta Yellow

" ######################################## "
" >>               EVENTS               << "
" ######################################## "

autocmd VimEnter    * :call Open()
autocmd VimLeave    * :call Close()
autocmd BufWinEnter * :call SetStatusLine()

autocmd InsertEnter * highlight Statusline ctermfg=Red
autocmd InsertLeave * highlight Statusline ctermfg=White

autocmd BufWinEnter * setl conceallevel=2 concealcursor=nv
autocmd BufWinEnter * syn match LeadingSpace /\(^\(\(    \)\|\t\)*   \)\@<=\( \)/ containedin=ALL conceal cchar=→
autocmd BufReadPre * setl conceallevel=2 concealcursor=nv
autocmd BufReadPre * syn match LeadingSpace /\(^\(\(    \)\|\t\)*   \)\@<=\( \)/ containedin=ALL conceal cchar=→

" ######################################## "
" >>            ABBREVIATION            << "
" ######################################## "

" ######################################## "
" >>            KEYS_MAPPING            << "
" ######################################## "

let mapleader = "V"

nnoremap <C-Up> <C-w><Up>
nnoremap <C-Down> <C-w><Down>
nnoremap <C-Left> <C-w><Left>
nnoremap <C-Right> <C-w><Right>

nnoremap <C-S-Up> <C-w>+
nnoremap <C-S-Down> <C-w>-
nnoremap <C-S-Right> <C-w>>
nnoremap <C-S-Left> <C-w><lt>

nnoremap chk :call Check()<CR>
nnoremap <C-k> :call Check()<CR>

nnoremap tls :call ToggleLeadingSpaces()<CR>
nnoremap tvs :call ToggleVimvarStatus()<CR>
nnoremap tvi :call ToggleVimvarIndex()<CR>

nnoremap exe :call Execute()<CR>
nnoremap sel :call ShowSelectedCommand()<CR>

" Move around in help
nnoremap <C-j> <C-]>

cnoremap <leader>t VimvarToggle
cnoremap <leader>r VimvarReset

cnoremap <leader>S VimvarSelectCommand
cnoremap <leader>D VimvarDeselectCommand

cnoremap <leader>a VimvarAdd
cnoremap <leader>i VimvarInsert
cnoremap <leader>s VimvarSet
cnoremap <leader>d VimvarDelete

" ######################################## "
" >>              COMMANDS              << "
" ######################################## "

command! -nargs=0 VimvarToggleStatus           :call s:vimvar.ToggleStatus()
command! -nargs=0 VimvarToggleIndex            :call s:vimvar.ToggleIndex()

command! -nargs=0 VimvarReset                  :call s:vimvar.Reset()
command! -nargs=1 VimvarResetArguments         :call s:vimvar.ResetArguments(<f-args>)

command! -nargs=1 VimvarSelectCommand          :call s:vimvar.SelectCommand(<f-args>)
command! -nargs=0 VimvarDeselectCommand        :call s:vimvar.DeselectCommand(<f-args>)

command! -nargs=+ VimvarAddCommand             :call s:vimvar.AddCommand(<f-args>)
command! -nargs=+ VimvarAddArguments           :call s:vimvar.AddArguments(<f-args>)

command! -nargs=+ VimvarInsertCommand          :call s:vimvar.InsertCommand(<f-args>)
command! -nargs=+ VimvarInsertArguments        :call s:vimvar.InsertArguments(<f-args>)

command! -nargs=+ VimvarSetCommand             :call s:vimvar.SetCommand(<f-args>)
command! -nargs=1 VimvarSetName                :call s:vimvar.SetName(<f-args>)
command! -nargs=* VimvarSetArguments           :call s:vimvar.SetArguments(<f-args>)

command! -nargs=* VimvarDeleteCommand          :call s:vimvar.DeleteCommand(<f-args>)
command! -nargs=* VimvarDeleteArguments        :call s:vimvar.DeleteArguments(<f-args>)

command! -nargs=0 VimvarExecute                :call s:vimvar.Execute()
command! -nargs=? VimvarSave                   :call s:vimvar.Save(<f-args>)
command! -nargs=? VimvarLoad                   :call s:vimvar.Load(<f-args>)

command! -nargs=0 Check                        :call Check()

" ######################################## "
" >>              VARIABLE              << "
" ######################################## "

" ######################################## "
" >>              FUNCTION              << "
" ######################################## "

function! SetStatusLine()
    setl statusline=\ %0.40f\ %3*\ %1*%m[%{strlen(&fenc)?&fenc:'none'},\ %{&ff}]%3*\ %1*%{GetStatusLineInfo()}%3*%=%5*\ %v:%l%2*\ /%6*\ %L%2*\ \ %P\ 
endfunction

function! GetStatusLineInfo()
    if s:vimvar.Enabled()
        let l:commandLine = s:vimvar.GetCommandLine()
        if l:commandLine != ''
            let l:commandLine = ' ' . l:commandLine . ' '
        endif
        return l:commandLine
    else
        return ''
    endif
endfunction

function! Open()
    let s:vimvar = NewVimvar().Load()
endfunction

function! Close()
    call s:vimvar.Save()
endfunction

function! ToggleLeadingSpaces()
    if &conceallevel == 0
        set conceallevel=2
        set listchars=tab:→\ ,trail:°
    else
        set conceallevel=0
        set listchars=tab:\ \ ,trail:°
    endif
endfunction

function! ToggleVimvarStatus()
    call s:vimvar.ToggleStatus()
endfunction

function! ToggleVimvarIndex()
    call s:vimvar.ToggleIndex()
endfunction

function! Execute()
    call s:vimvar.Execute()
endfunction

function! ShowSelectedCommand()
    echo s:vimvar.Selected()
endfunction

function! Check()
    if expand("%:e") == "bash" || expand("%") == ".bashrc"
        w
        echo system("shellcheck " . expand("%"))
    else
        echo ""
    endif
endfunction

" ######################################## "
"                   TEST                   "
" ######################################## "

