# Git

## Clone

function github_clone -a ssh_name repo_shorthand repo_name
    set ssh_path /Users/$USER/.ssh/config/id_rsa_$ssh_name

    if test -d $repo_name
        set repo_name (echo $repo_shorthand | cut -d '/' -f2)
    end

    ssh-agent bash -c "ssh-add $ssh_path; git clone git@github.com:$repo_shorthand.git $repo_name"
    cd $repo_name
    gus $ssh_name
end

function gitlab_clone -a ssh_name repo_ssh_address repo_name
    set ssh_path /Users/$USER/.ssh/config/id_rsa_$ssh_name

    ssh-agent bash -c "ssh-add $ssh_path; git clone $repo_ssh_address $repo_name"
    cd $repo_name
    gus $ssh_name
end

## Caches and untracked files

alias grm   'git rm -r --cached .'
alias gcln  'git clean -fd'

## Status

alias gs    'git status'

function gsw
    set git_status .git/status
    set git_temp_status .git/tmp_status

    rm -rf $git_status

    while true
        script -q $git_temp_status git --no-optional-locks status > /dev/null
        set status_diff (cmp $git_status $git_temp_status 2>&1)
        if not test -d $status_diff
            rm $git_status
            mv $git_temp_status $git_status
            clear and printf '\e[3J'
            cat $git_status
        end
        sleep 2
    end
end

alias gl    'git log'

function glw
    set git_log .git/log
    set git_temp_log .git/tmp_log

    rm -rf $git_log

    while true
        script -q $git_temp_log git --no-optional-locks --no-pager log --abbrev-commit --pretty=oneline -20 > /dev/null
        set log_diff (cmp $git_log $git_temp_log 2>&1)
        if not test -d $log_diff
            rm $git_log
            mv $git_temp_log $git_log
            clear and printf '\e[3J'
            cat $git_log
        end
        sleep 2
    end
end

## Branching

alias gb       'git branch'
alias gba      'gb -a'
alias gbm      'git branch -m'

function gbcln
    # git for-each-ref --format='%(refname:short) %(upstream)' refs/heads/ | awk '$2 !~/^refs\/remotes/' | xargs git branch -D
    git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -d
end

function gco -a branch_search_term
    set local_branch (branch_containing $branch_search_term)

    if not test -d $local_branch
        git checkout $local_branch
    else
        set remote_branch (remote_branch_containing $branch_search_term)
        gcor $remote_branch
    end
end

function gcop
    gco $argv
    gp
end

alias mtr       'git checkout master'
alias mtrp      'mtr and gp'
alias rel       'git checkout release'
alias relp      'rel and gp'

function gcof -a files -w 'git checkout --'
	git checkout -- $files
end

alias gcoa      'git checkout -- .'

alias gbco      'git checkout -b'

function gcor -a branch_search_term
    gf
    git checkout -t (remote_branch_containing $branch_search_term)
    gbt
    gp
end

function gcora
    set all_remote_branches (git branch -r | cut -c 3-)
    gf
    for remote_branch in $all_remote_branches
        git checkout -t $remote_branch
        gbt
    end
end

function gbt
    set current_branch (current_branch)
    git branch -u origin/$current_branch $current_branch
end

function gbd -a branch_search_term
    set branch (branch_containing $branch_search_term)
    git branch -d $branch
end

function gbd! -a branch_search_term
    set branch (branch_containing $branch_search_term)
    git branch -D $branch
end

function gbdr -a branch_search_term
    set branch (branch_containing $branch_search_term)
    git push origin :$branch
end

## Resetting

alias grf	 'git reset HEAD'
alias gra    'git reset .'

function gr
	git reset HEAD~$argv
end

function gr!
	git reset HEAD~$argv --hard
end

## Pulling

alias gf     'git fetch origin'
function gp
    gbt
    git pull origin --tags --rebase
end

## Diffing

alias gd     'git diff --color --indent-heuristic | diff-so-fancy'
alias gds    'git diff --staged --color --indent-heuristic | diff-so-fancy'
alias gda    'git diff --color --indent-heuristic HEAD | diff-so-fancy'
alias gsh    'git show'

function gdaw
    set git_diff .git/diff
    set git_tmp_diff .git/tmp_diff

    rm $git_diff
    rm $git_tmp_diff

    while true
        script -q $git_tmp_diff git --no-optional-locks --no-pager diff HEAD > /dev/null
        if test -e $git_diff
		    set diff_diff (cmp $git_diff $git_tmp_diff 2>&1)
		    if not test -d $diff_diff
		        mv -f $git_tmp_diff $git_diff
		        clear and printf '\e[3J'
		        if test -s $git_diff
		    		git diff --color --indent-heuristic HEAD ':(exclude)*.pbxproj' | diff-so-fancy
			    else
			    	cat (random choice $FISH_CONFIG_PATH/resources/ascii/*)
			    end
	        end
	    else
	    	mv -f $git_tmp_diff $git_diff
	    	clear and printf '\e[3J'
	    	if test -s $git_diff
	    		git diff --color --indent-heuristic HEAD ':(exclude)*.pbxproj' | diff-so-fancy
		    else
		    	cat (random choice $FISH_CONFIG_PATH/resources/ascii/*)
		    end
		end
        sleep 2
    end
end

## Staging

function ga -a files -w 'git add'
    switch (count $files)
    case 0
        git gui
    case '*'
        git add $files
    end
end

alias gaa    'git add .'

## Stashing

alias gstl   'git stash list'

alias gst    'git stash --include-untracked --quiet'
alias gstf	 'git stash push --include-untracked --quiet'

function gsts -a index
    git stash show -p stash@\{$index\}
end

function gsta
    if test -d $argv
        git stash apply --index --quiet
    else
        git stash apply stash@\{$argv\} --index --quiet
    end
end

function gstd
    git stash drop stash@\{$argv\}
end

alias gstcln 'git stash clear .'

## Commiting

alias gc     'git commit'
alias gcm    'git commit -m'
alias gca    'git commit --amend'
alias gce    'git commit --allow-empty'

function gct
	set ticket_name (_git_branch_name_short)
	gcm "[$ticket_name] $argv"
end

alias gcp    'git cherry-pick'

## Tagging

alias gt     'git tag'

function gtd
    git tag -d $argv
end

function gtd!
    git tag -D $argv
end

function gtdr
    git push origin :refs/tags/$argv
end

## Merging

function gm -a branch_search_term
	set current_branch (current_branch)
	set branch_to_merge (branch_containing $branch_search_term)
	gcop $branch_to_merge
	git checkout $current_branch
    git merge $branch_to_merge
end

alias gmmtr  'gm master'
alias gmrel	 'gm release'

## Pushing

alias gps    'git push -u origin HEAD'
alias gps!   'gps --force'
