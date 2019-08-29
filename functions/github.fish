function gug
    ssh-keygen -t rsa -b 4096 -f /Users/$USER/.ssh/config/id_rsa_$argv[1] -C "$argv[2]" -N ""
    pbcopy < ~/.ssh/config/id_rsa_$argv[1].pub
end

function gua
    set ssh_path /Users/$USER/.ssh/config/id_rsa_$argv
    ssh-add $ssh_path
    ssh -i $ssh_path -T git@github.com
end

function gus
    set username $argv
    set ssh_path /Users/$USER/.ssh/config/id_rsa_$username
    git config core.sshCommand "ssh -i $ssh_path"
    set email (cat $ssh_path.pub | cut -d ' ' -f3)
    git config user.name $username
    git config user.email $email
end
