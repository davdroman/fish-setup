alias fl 	'fastlane'

function flmatch -d 'Syncs certificates' -a environment username git_url
    set ssh_path /Users/$USER/.ssh/config/id_rsa_$username

    env GIT_SSH_COMMAND="ssh -i $ssh_path" \
    fastlane match $environment \
    --git_url "$git_url" \
    --git_full_name "$username" \
    --git_user_email (cat $ssh_path.pub | cut -d ' ' -f3)
end
