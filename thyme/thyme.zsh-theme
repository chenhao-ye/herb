# Based on bira, gnzh, bullet-train theme
# bira: https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/bira.zsh-theme
# gnzh: https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/gnzh.zsh-theme
# bullet-train: https://github.com/caiogondim/bullet-train.zsh/blob/master/bullet-train.zsh-theme

setopt prompt_subst

() {

local _USER _PROMPT _HOST

# set THYME_USER_AS if you want to show a name different from the user name
if [[ -z "$THYME_USER_AS" ]]; then
	_USER="%n"
else
	_USER="$THYME_USER_AS"
fi

if [[ "$THYME_NO_HOST" == "true" ]]; then
	_HOST=""
else
	_HOST="@%m"
fi

if [[ $UID -ne 0 ]]; then # normal user
	_USER="%F{green}${_USER}%f"
	_PROMPT="%f➤%f"
else # root
	_USER="%F{red}${_USER}%f"
	_PROMPT="%F{red}➤f"
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
	_HOST="%F{cyan}${_HOST}%f" # SSH
else
	_HOST="%F{green}${_HOST}%f" # no SSH
fi

local _CWD=" %B%F{blue}%~%f%b"
local _NEWLINE='
'
local _GIT_PROMPT='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX=" %F{yellow}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%f"

# from bbullet-train:
if [ ! -n "${BULLETTRAIN_GIT_DIRTY+1}" ]; then
  ZSH_THEME_GIT_PROMPT_DIRTY="✘"
else
  ZSH_THEME_GIT_PROMPT_DIRTY=$BULLETTRAIN_GIT_DIRTY
fi
if [ ! -n "${BULLETTRAIN_GIT_CLEAN+1}" ]; then
  ZSH_THEME_GIT_PROMPT_CLEAN="✔"
else
  ZSH_THEME_GIT_PROMPT_CLEAN=$BULLETTRAIN_GIT_CLEAN
fi
if [ ! -n "${BULLETTRAIN_GIT_ADDED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_ADDED="✚"
else
  ZSH_THEME_GIT_PROMPT_ADDED=$BULLETTRAIN_GIT_ADDED
fi
if [ ! -n "${BULLETTRAIN_GIT_MODIFIED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_MODIFIED="✹"
else
  ZSH_THEME_GIT_PROMPT_MODIFIED=$BULLETTRAIN_GIT_MODIFIED
fi
if [ ! -n "${BULLETTRAIN_GIT_DELETED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_DELETED="✖"
else
  ZSH_THEME_GIT_PROMPT_DELETED=$BULLETTRAIN_GIT_DELETED
fi
if [ ! -n "${BULLETTRAIN_GIT_UNTRACKED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_UNTRACKED="✭"
else
  ZSH_THEME_GIT_PROMPT_UNTRACKED=$BULLETTRAIN_GIT_UNTRACKED
fi
if [ ! -n "${BULLETTRAIN_GIT_RENAMED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_RENAMED="➜"
else
  ZSH_THEME_GIT_PROMPT_RENAMED=$BULLETTRAIN_GIT_RENAMED
fi
if [ ! -n "${BULLETTRAIN_GIT_UNMERGED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_UNMERGED="═"
else
  ZSH_THEME_GIT_PROMPT_UNMERGED=$BULLETTRAIN_GIT_UNMERGED
fi
if [ ! -n "${BULLETTRAIN_GIT_AHEAD+1}" ]; then
  ZSH_THEME_GIT_PROMPT_AHEAD="⬆"
else
  ZSH_THEME_GIT_PROMPT_AHEAD=$BULLETTRAIN_GIT_AHEAD
fi
if [ ! -n "${BULLETTRAIN_GIT_BEHIND+1}" ]; then
  ZSH_THEME_GIT_PROMPT_BEHIND="⬇"
else
  ZSH_THEME_GIT_PROMPT_BEHIND=$BULLETTRAIN_GIT_BEHIND
fi
if [ ! -n "${BULLETTRAIN_GIT_DIVERGED+1}" ]; then
  ZSH_THEME_GIT_PROMPT_DIVERGED="⬍"
else
  ZSH_THEME_GIT_PROMPT_DIVERGED=$BULLETTRAIN_GIT_PROMPT_DIVERGED
fi

local _JOB="%(1j.%F{cyan}[⚙]%f.)"
PROMPT="${_NEWLINE}╭─[${_USER}${_HOST}]${_JOB}${_CWD}${_GIT_PROMPT}
╰─$_PROMPT "

if [[ "$THYME_TIMER_DISABLED" == "true" ]]; then
	RPROMPT="${_RET}"
	return
fi

# Based on http://stackoverflow.com/a/32164707/3859566
function displaytime {
	local T=$1
	local D=$((T/60/60/24))
	local H=$((T/60/60%24))
	local M=$((T/60%60))
	local S=$((T%60))
	[[ $D > 0 ]] && printf '%dd' $D
	[[ $H > 0 ]] && printf '%dh' $H
	[[ $M > 0 ]] && printf '%dm' $M
	printf '%ds' $S
}

preexec() {
	THYME_TIMESTAMP=$(date +%s)
}

precmd() {
	local _DURATION=""
	if [[ -n "$THYME_TIMESTAMP" ]]; then
		_DURATION=$(( $(date +%s) - $THYME_TIMESTAMP ))
		_DURATION="%F{yellow}[$(displaytime $_DURATION)]%f"
	fi
	local _RET="%(?..%F{red}%?↵%f )"
	RPROMPT="${_RET}${_DURATION}%F{green}[$(date +%H:%M:%S)]%f"
}

}
