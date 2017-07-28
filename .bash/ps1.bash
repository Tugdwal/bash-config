#!/bin/bash


user()
{
    echo "\u"
}

hostname()
{
    echo "\h"
}

dir()
{
    echo "\w"
}

root()
{
    if [ "$UID" = "0" ]; then
        echo "#"
    else
        echo "$"
    fi
}

sh_lvl()
{
    if [ "${SHLVL}" -gt 1 ]; then
        echo "[${light_green}${SHLVL}${normal}]"
    fi
}

is_vim_shell()
{
    if [ ! -z "$VIMRUNTIME" ]; then
        echo "[${light_yellow}vim${normal}]"
    fi
}

prompt_git()
{
    if [ "${PS1_CONFIG_GIT}" != "no" ] && [ -e "./.git" ]; then
        local git_ref
        local git_branch
        local git_status
        local git_state=""

        # Get the branch reference
        git_ref=$(command git symbolic-ref -q HEAD 2> /dev/null) || git_ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
        git_branch=${git_ref#refs/heads/}

        # Get the status
        git_status=$(command git status --porcelain --untracked-files=no)

        case "${PS1_CONFIG_GIT}" in
            "branch")
                if [ -n "${git_status}" ]; then
                    git_state+=${light_red}${char_cross}${normal}
                else
                    git_state+=${light_green}${char_check}${normal}
                fi
            ;;
            "all")
            if [ -n "${git_status}" ]; then
                local IFS=$'\n'
                local t=(${git_status})

                for file in "${t[@]}"; do
                    if [ "${file:1:1}" != " " ]; then
                        git_state+="${file:3} ${light_red}${char_cross}${normal} | "
                    else
                        git_state+="${file:3} ${light_green}${char_check}${normal} | "
                    fi
                done

                git_state=${git_state:0:${#git_state}-3}
            else 
                git_state=${light_green}${char_check}${normal}
            fi
            ;;
            *)
        esac

        echo -e "[${git_branch} ${char_arrow_right} ${git_state}]"
    fi
}

prompt()
{
    PS1="${normal}[${light_gray}$(user)${normal}@${light_gray}$(hostname)${normal}][${light_red}$(dir)${normal}]$(prompt_git)$(sh_lvl)$(is_vim_shell)[$(root)]\n> "
}

PROMPT_COMMAND=prompt

PS1_CONFIG_GIT="branch"

# Configure PS1
pscon()
{
    pscon_help()
    {
        echo -e "Usage: pscon [OPTION]...\n"
        echo "Optional arguments:"
        echo -e "  -h, --help                   display this help and exit"
        echo -e "  -g, --git [no|branch|all]    switch to given mode or rotate between modes if none is given"
    }

    if [ ${#} -eq 0 ]; then
        pscon_help
    fi

    while [ ${#} -gt 0 ]; do
        case "$1" in
            "-h" | "--help")
            pscon_help
            shift
            ;;
            "-g" | "--git")
            shift
            if [ "$1" = "no" ] || [ "$1" = "branch" ] || [ "$1" = "all" ]; then
                PS1_CONFIG_GIT="$1"
                shift
            else
                case "${PS1_CONFIG_GIT}" in
                    "no")
                    PS1_CONFIG_GIT="branch";;
                    "branch")
                    PS1_CONFIG_GIT="all";;
                    "all")
                    PS1_CONFIG_GIT="no";;
                    *)
                    ;;
                esac
            fi
            echo "Value : ${PS1_CONFIG_GIT}"
            ;;
            *)
            shift
            ;;
        esac
    done
}

