alias rf    'source ~/.config/fish/config.fish'

function _refresh --on-event fish_preexec
	if not test -n $argv[1]
		source ~/.config/fish/config.fish
	end
end

function ef
    if test -d $argv
        subl $FISH_CONFIG_PATH
    else
        subl $FISH_CONFIG_PATH/functions/$argv.fish
    end
end

alias cdf   "cd '$FISH_CONFIG_PATH'"
alias tff   "open -a Finder '$FISH_CONFIG_PATH'"
alias sublf "subl '$FISH_CONFIG_PATH'"

function fish_greeting

end
