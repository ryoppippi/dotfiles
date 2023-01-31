function __fish_ghq_needs_command
    set cmd (commandline -opc)
    if [ (count $cmd) -eq 1 -a $cmd[1] = "ghq" ]
        return 0
    end
    return 1
end

function __fish_ghq_using_command
    set cmd (commandline -opc)
    if [ (count $cmd) -gt 1 ]
        if [ $argv[1] = $cmd[2] ]
            return 0
        end
    end
    return 1
end

# Help
function __fish_ghq_help_topics
    for c in get list root create
        printf "%s\thelp topic\n" $c
    end
end

function __fish_ghq_vcs
    for c in git subversion git-svn mercurial darcs
        printf "%s\tVCS\n" $c
    end
    printf "github\tAlias for git\n"
    printf "svn\tAlias for subversion\n"
    printf "hg\tAlias for mercurial\n"
end

complete -f -c ghq -n "__fish_ghq_needs_command" -a help -d "Shows a list of commands or help for one command"
complete -f -c ghq -n "__fish_ghq_using_command help" -a "(__fish_ghq_help_topics)"

complete -f -c ghq -n "__fish_ghq_needs_command" -a get -d "Clone/sync with a remote repository"
complete -f -c ghq -n "__fish_ghq_using_command get" -l update -s u -d "Update local repository if cloned already"
complete -f -c ghq -n "__fish_ghq_using_command get" -s p -d "Clone with SSH"
complete -f -c ghq -n "__fish_ghq_using_command get" -l shallow -d "Do a shallow clone"
complete -f -c ghq -n "__fish_ghq_using_command get" -l look -s l -d "Look after get"
complete -f -c ghq -n "__fish_ghq_using_command get" -l vcs -d "Specify VCS backend for cloning" -r -a "(__fish_ghq_vcs)"
complete -f -c ghq -n "__fish_ghq_using_command get" -l silent -s s -d "Clone or update silently"
complete -f -c ghq -n "__fish_ghq_using_command get" -l no-recursive -d "Prevent recursive fetching"
complete -f -c ghq -n "__fish_ghq_using_command get" -l branch -s b -d "Specify branch name. This flag implies --single-branch on Git"
complete -f -c ghq -n "__fish_ghq_using_command get" -l parallel -s P -d "Import parallely"
complete -f -c ghq -n "__fish_ghq_using_command get" -l help -s h -d "Show help"

complete -f -c ghq -n "__fish_ghq_needs_command" -a list -d "List local repositories"
complete -f -c ghq -n "__fish_ghq_using_command list" -l exact -s e -d "Perform an exact match"
complete -f -c ghq -n "__fish_ghq_using_command list" -l vcs -d "Specify VCS backend for matching" -r -a "(__fish_ghq_vcs)"
complete -f -c ghq -n "__fish_ghq_using_command list" -l full-path -s p -d "Print full paths"
complete -f -c ghq -n "__fish_ghq_using_command list" -l unique -d "Print unique subpaths"
complete -f -c ghq -n "__fish_ghq_using_command list" -l help -s h -d "Show help"

complete -f -c ghq -n "__fish_ghq_needs_command" -a root -d "Show repositories' root"
complete -f -c ghq -n "__fish_ghq_using_command root" -l all -d "Show all roots"
complete -f -c ghq -n "__fish_ghq_using_command root" -l help -s h -d "Show help"

complete -f -c ghq -n "__fish_ghq_needs_command" -a create -d "Create a new repository"
complete -f -c ghq -n "__fish_ghq_using_command create" -l vcs -d "Specify VCS backend explicitly" -r -a "(__fish_ghq_vcs)"
complete -f -c ghq -n "__fish_ghq_using_command create" -l help -s h -d "Show help"

complete -f -c ghq -n "__fish_ghq_needs_command" -l help -s h -d "Show help"
complete -f -c ghq -n "__fish_ghq_needs_command" -l version -s v -d "Print the version"
