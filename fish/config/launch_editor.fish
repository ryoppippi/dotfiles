if test -n "$LAUNCH_EDITOR"
    return
end

set -l this_basename (dirname (status -f))
set -l script_name (path resolve $this_basename/_launch_editor)
set -gx LAUNCH_EDITOR $script_name
