autoload -U add-zsh-hook
autoload -Uz vcs_info

local c0=$'\e[m'
local c1=$'\e[38;5;245m'
local c2=$'\e[38;5;250m'
local c3=$'\e[38;5;242m'
local c4=$'\e[38;5;197m'
local c5=$'\e[38;5;225m'
local c6=$'\e[38;5;240m'
local c7=$'\e[38;5;242m'
local c8=$'\e[38;5;244m'
local c9=$'\e[38;5;162m'
local c10=$'\e[1m'
local c11=$'\e[38;5;208m\e[1m'
local c12=$'\e[38;5;142m\e[1m'
local c13=$'\e[38;5;196m\e[1m'

zsh_path() {
  local colors
  colors=$(echoti colors)

  local -A yellow
  yellow=(
    1  '%F{228}'   2  '%F{222}'   3  '%F{192}'   4  '%F{186}'
    5  '%F{227}'   6  '%F{221}'   7  '%F{191}'   8  '%F{185}'
    9  '%F{226}'   10  '%F{220}'   11  '%F{190}'   12  '%F{184}'
    13  '%F{214}'   14  '%F{178}'  15  '%F{208}'   16  '%F{172}'
    17  '%F{202}'   18  '%F{166}'
  )

  local dir i=1
  for dir (${(s:/:)PWD}); do
    if [[ $i -eq 1 ]]; then
      if [[ $colors -ge 256 ]]; then
        print -Pn "%F{blue}%B /%b"
      else
        print -Pn "\e[31;1m /"
      fi
    else
      if [[ $colors -ge 256 ]]; then
        print -Pn "${yellow[$i]:-%f} » "
      else
        print -Pn "%F{yellow} > "
      fi
    fi

    (( i++ ))

    if [[ $colors -ge 256 ]]; then
      print -Pn "%F{blue}$dir"
    else
      print -Pn "%F{blue}$dir"
    fi
  done
  print -Pn "%f"
}

if [ "$TERM" = linux ]; then
  c1=$'\e[34;1m'
  c2=$'\e[35m'
  c3=$'\e[31m'
  c4=$'\e[31;1m'
  c5=$'\e[32m'
  c6=$'\e[32;1m'
  c7=$'\e[33m'
  c8=$'\e[33;1m'
  c9=$'\e[34m'
  c11=$'\e[35;1m'
  c12=$'\e[36m'
  c13=$'\e[31;1m'
fi

zstyle ':vcs_info:*' actionformats \
    "%{$c8%}< %f%s %{$c8%}>%{$c7%}-[ %{$c9%}%{$c11%}%b%F{3}|%F{1}%a%{$c7%} ]%{$reset_color%}%f "

zstyle ':vcs_info:*' formats \
    "%{$c8%}< %f%s %{$c8%}>%{$c7%}-[ %{$c9%}%{$c11%}%b%{$c7%} ]%{$reset_color%}%f "

zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git

add-zsh-hook precmd prompt_jnrowe_precmd

prompt_jnrowe_precmd () {
  vcs_info
  if [ "${vcs_info_msg_0_}" = "" ]; then
    dir_status="$c6( %D{%H:%M:%S} )-> %{$c1%}%n%{$fg_bold[green]%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$(zsh_path)%}"
    PROMPT='%{$fg_bold[green]%}%p%{$reset_color%}${vcs_info_msg_0_}${dir_status} ${ret_status}%{$reset_color%}
 %{$c1%}(%{$c5%}%?%{$c1%})->%{$c0%} '
  else
    dir_status="$c6( %D{%H:%M:%S} )-> %{$c1%}%n%{$fg_bold[green]%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$(zsh_path)%}"
    PROMPT='${vcs_info_msg_0_}
%{$fg_bold[green]%}%p%{$reset_color%}${dir_status}%{$reset_color%}
 %{$c1%}(%{$c5%}%?%{$c1%})->%{$c0%} '
  fi
}
