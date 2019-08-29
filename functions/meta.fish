alias rf    'source ~/.config/fish/config.fish'

function ef
    if test -d $argv
        subl $FISH_CONFIG_PATH
    else
        subl $FISH_CONFIG_PATH/functions/$argv.fish
    end
end

function cdf
	cd $FISH_CONFIG_PATH
end

function fish_greeting

end
