RED="\[\e[0;36m\]"
GRAY="\[\e[0;37m\]"
YELLOW="\[\e[0;33m\]"
BLUE="\[\e[0;34m\]"
PURPLE="\[\e[0;35m\]"
GREEN="\[\e[0;32m\]"
WHITE="\[\e[0;37m\]"
BLOODRED="\[\e[1;31m\]"
CYAN="\[\e[1;34m\]"
GRAYBG_WHITEFG="\[\e[37;37m\]"
LIGHT_CYAN="\[\e[0;96m\]"
LIGHT_GREEN="\[\e[1;32m\]"
TXTRST="\[\e[0m\]"
SEPARATOR=◥
DOWNBAR='\342\224\214'
HORBAR='\342\224\200'
#HORBAR='|'
UPBAR='\342\224\224'
HORBARPLUG='\342\225\274'
CROSS='\342\234\227'
SMILEY=🙂
GHOUL=👻
DOTBLK='\u2529'
YAY=${SMILEY}
UHOH=🙃
ARROW=↠
GITSYM=ᛘ
K8SSYM=☸
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

function k8s_module {	
  context=$(k config current-context 2> /dev/null)
  if [[ ! -z "$context" ]]; then
	 echo $WHITE$K8SSYM$CYAN[$context]$WHITE
  fi 
  
}
function git_module {
    if ! git ls-files >& /dev/null; then
	    exit
    fi
    #gitprompt=$(echo $(git_super_status))
    gitprompt=$(echo $(__git_ps1))
    echo $WHITE$GITSYM${CYAN}["${gitprompt:1:${#gitprompt}-2}"]$WHITE
}

function file_module {
    files=$(ls | wc -l | xargs) 
    echo $WHITE$SEPARATOR${LIGHT_GREEN}[${files}'|'$(ls -lah | grep -m 1 total | sed 's/total //')]$WHITE
}

function time_module {
	echo $WHITE$SEPARATORS$YELLOW[$(date +"%T")]$WHITE
}

function end_module {
    echo "\n"$GRAY$UPBAR$HORBAR$HORBAR${HORBARPLUG} $TXTRST
}

function begin_module {
    echo $GRAY$DOWNBAR$HORBAR
}

function retval_module {
    echo $(if [[ $? == 0 ]]; then echo "$GREEN[${YAY}]"; else echo "$BLOODRED[${UHOH}]"; fi)$WHITE
}

function user_module {
     echo $SEPARATOR$(if [[ ${EUID} == 0 ]]; then echo [$BLOODRED'\h']; else echo [$YELLOW'\u']; fi)$WHITE
}

function location_module {
    echo $SEPARATOR$LIGHT_GREEN["\w"]$WHITE
}

function set_bash_prompt {
	SELECT=$(retval_module)
	PS1=$(begin_module)${SELECT}$(user_module)$(location_module)$(git_module)$(k8s_module)$(end_module)
}
GIT_PS1_SHOWUPSTREAM="auto"     # '<' behind, '>' ahead, '<>' diverged, '=' no difference
GIT_PS1_SHOWDIRTYSTATE=1        # staged '+', unstaged '*'
GIT_PS1_SHOWSTASHSTATE=1        # '$' something is stashed
GIT_PS1_SHOWUNTRACKEDFILES=1    # '%' untracked files
PROMPT_COMMAND=set_bash_prompt
