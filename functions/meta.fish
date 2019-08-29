alias rf    'source ~/.config/fish/config.fish'

function ef
    if test -d $argv
        subl ~/.config/fish/config.fish
    else
        subl $FISH_CONFIG_PATH/functions/$argv.fish
    end
end

function fish_greeting
    
end