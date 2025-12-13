function source_venv_py -d "Source the virtualenv for the current project"
    test -e ./venv && source ./venv/bin/activate.fish && return
    test -e ./.venv && source ./.venv/bin/activate.fish && return
    echo "No virtualenv found"
end
