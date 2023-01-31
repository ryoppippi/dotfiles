function __fish_poetry_5b9789a383c42c47_complete_no_subcommand
    for i in (commandline -opc)
        if contains -- $i about add build cache check config debug env export help init install lock new publish remove run search self shell show update version
            return 1
        end
    end
    return 0
end

# global options
complete -c poetry -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -l ansi -d 'Force ANSI output'
complete -c poetry -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -l help -d 'Display this help message'
complete -c poetry -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -l no-ansi -d 'Disable ANSI output'
complete -c poetry -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -l no-interaction -d 'Do not ask any interactive question'
complete -c poetry -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -l quiet -d 'Do not output any message'
complete -c poetry -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -l verbose -d 'Increase the verbosity of messages: "-v" for normal output, "-vv" for more verbose output and "-vvv" for debug'
complete -c poetry -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -l version -d 'Display this application version'

# commands
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a about -d 'Shows information about Poetry.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a add -d 'Adds a new dependency to pyproject.toml.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a build -d 'Builds a package, as a tarball and a wheel by default.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a cache -d 'Interact with Poetry\'s cache'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a check -d 'Checks the validity of the pyproject.toml file.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a config -d 'Manages configuration settings.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a debug -d 'Debug various elements of Poetry.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a env -d 'Interact with Poetry\'s project environments.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a export -d 'Exports the lock file to alternative formats.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a help -d 'Display the manual of a command'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a init -d 'Creates a basic pyproject.toml file in the current directory.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a install -d 'Installs the project dependencies.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a lock -d 'Locks the project dependencies.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a new -d 'Creates a new Python project at <path>.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a publish -d 'Publishes a package to a remote repository.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a remove -d 'Removes a package from the project dependencies.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a run -d 'Runs a command in the appropriate environment.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a search -d 'Searches for packages on remote repositories.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a self -d 'Interact with Poetry directly.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a shell -d 'Spawns a shell within the virtual environment.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a show -d 'Shows information about packages.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a update -d 'Update the dependencies as according to the pyproject.toml file.'
complete -c poetry -f -n '__fish_poetry_5b9789a383c42c47_complete_no_subcommand' -a version -d 'Shows the version of the project or bumps it when a validbump rule is provided.'

# command options

# about

# add
complete -c poetry -A -n '__fish_seen_subcommand_from add' -l allow-prereleases -d 'Accept prereleases.'
complete -c poetry -A -n '__fish_seen_subcommand_from add' -l dev -d 'Add as a development dependency.'
complete -c poetry -A -n '__fish_seen_subcommand_from add' -l dry-run -d 'Output the operations but do not execute anything (implicitly enables --verbose).'
complete -c poetry -A -n '__fish_seen_subcommand_from add' -l extras -d 'Extras to activate for the dependency.'
complete -c poetry -A -n '__fish_seen_subcommand_from add' -l optional -d 'Add as an optional dependency.'
complete -c poetry -A -n '__fish_seen_subcommand_from add' -l platform -d 'Platforms for which the dependency must be installed.'
complete -c poetry -A -n '__fish_seen_subcommand_from add' -l python -d 'Python version for which the dependency must be installed.'

# build
complete -c poetry -A -n '__fish_seen_subcommand_from build' -l format -d 'Limit the format to either sdist or wheel.'

# cache

# check

# config
complete -c poetry -A -n '__fish_seen_subcommand_from config' -l list -d 'List configuration settings.'
complete -c poetry -A -n '__fish_seen_subcommand_from config' -l local -d 'Set/Get from the project\'s local configuration.'
complete -c poetry -A -n '__fish_seen_subcommand_from config' -l unset -d 'Unset configuration setting.'

# debug

# env

# export
complete -c poetry -A -n '__fish_seen_subcommand_from export' -l dev -d 'Include development dependencies.'
complete -c poetry -A -n '__fish_seen_subcommand_from export' -l extras -d 'Extra sets of dependencies to include.'
complete -c poetry -A -n '__fish_seen_subcommand_from export' -l format -d 'Format to export to.'
complete -c poetry -A -n '__fish_seen_subcommand_from export' -l output -d 'The name of the output file.'
complete -c poetry -A -n '__fish_seen_subcommand_from export' -l with-credentials -d 'Include credentials for extra indices.'
complete -c poetry -A -n '__fish_seen_subcommand_from export' -l without-hashes -d 'Exclude hashes from the exported file.'

# help

# init
complete -c poetry -A -n '__fish_seen_subcommand_from init' -l author -d 'Author name of the package.'
complete -c poetry -A -n '__fish_seen_subcommand_from init' -l dependency -d 'Package to require, with an optional version constraint, e.g. requests:^2.10.0 or requests=2.11.1.'
complete -c poetry -A -n '__fish_seen_subcommand_from init' -l description -d 'Description of the package.'
complete -c poetry -A -n '__fish_seen_subcommand_from init' -l dev-dependency -d 'Package to require for development, with an optional version constraint, e.g. requests:^2.10.0 or requests=2.11.1.'
complete -c poetry -A -n '__fish_seen_subcommand_from init' -l license -d 'License of the package.'
complete -c poetry -A -n '__fish_seen_subcommand_from init' -l name -d 'Name of the package.'

# install
complete -c poetry -A -n '__fish_seen_subcommand_from install' -l dry-run -d 'Output the operations but do not execute anything (implicitly enables --verbose).'
complete -c poetry -A -n '__fish_seen_subcommand_from install' -l extras -d 'Extra sets of dependencies to install.'
complete -c poetry -A -n '__fish_seen_subcommand_from install' -l no-dev -d 'Do not install the development dependencies.'
complete -c poetry -A -n '__fish_seen_subcommand_from install' -l no-root -d 'Do not install the root package (the current project).'

# lock

# new
complete -c poetry -A -n '__fish_seen_subcommand_from new' -l name -d 'Set the resulting package name.'
complete -c poetry -A -n '__fish_seen_subcommand_from new' -l src -d 'Use the src layout for the project.'

# publish
complete -c poetry -A -n '__fish_seen_subcommand_from publish' -l build -d 'Build the package before publishing.'
complete -c poetry -A -n '__fish_seen_subcommand_from publish' -l cert -d 'Certificate authority to access the repository.'
complete -c poetry -A -n '__fish_seen_subcommand_from publish' -l client-cert -d 'Client certificate to access the repository.'
complete -c poetry -A -n '__fish_seen_subcommand_from publish' -l password -d 'The password to access the repository.'
complete -c poetry -A -n '__fish_seen_subcommand_from publish' -l repository -d 'The repository to publish the package to.'
complete -c poetry -A -n '__fish_seen_subcommand_from publish' -l username -d 'The username to access the repository.'

# remove
complete -c poetry -A -n '__fish_seen_subcommand_from remove' -l dev -d 'Remove a package from the development dependencies.'
complete -c poetry -A -n '__fish_seen_subcommand_from remove' -l dry-run -d 'Output the operations but do not execute anything (implicitly enables --verbose).'

# run

# search

# self

# shell

# show
complete -c poetry -A -n '__fish_seen_subcommand_from show' -l all -d 'Show all packages (even those not compatible with current system).'
complete -c poetry -A -n '__fish_seen_subcommand_from show' -l latest -d 'Show the latest version.'
complete -c poetry -A -n '__fish_seen_subcommand_from show' -l no-dev -d 'Do not list the development dependencies.'
complete -c poetry -A -n '__fish_seen_subcommand_from show' -l outdated -d 'Show the latest version but only for packages that are outdated.'
complete -c poetry -A -n '__fish_seen_subcommand_from show' -l tree -d 'List the dependencies as a tree.'

# update
complete -c poetry -A -n '__fish_seen_subcommand_from update' -l dry-run -d 'Output the operations but do not execute anything (implicitly enables --verbose).'
complete -c poetry -A -n '__fish_seen_subcommand_from update' -l lock -d 'Do not perform operations (only update the lockfile).'
complete -c poetry -A -n '__fish_seen_subcommand_from update' -l no-dev -d 'Do not update the development dependencies.'

# version
