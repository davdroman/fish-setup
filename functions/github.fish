function gug -d 'Generates new ssh key' -a username email
    ssh-keygen -t rsa -b 4096 -f /Users/$USER/.ssh/config/id_rsa_$username -C "$email" -N ""
    pbcopy < ~/.ssh/config/id_rsa_$username.pub
end

function gua -d 'Adds user key to ssh and attempts GitHub authentication' -a username
    set ssh_path /Users/$USER/.ssh/config/id_rsa_$username
    ssh-add $ssh_path
    ssh -i $ssh_path -T git@github.com
end

function gus -d 'Sets user key to be used in a specific repo' -a username
    set ssh_path /Users/$USER/.ssh/config/id_rsa_$username
    git config core.sshCommand "ssh -i $ssh_path"
    set email (cat $ssh_path.pub | cut -d ' ' -f3)
    git config user.name $username
    git config user.email $email
end
