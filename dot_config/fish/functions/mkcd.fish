function mkcd
  if test (count $argv) -eq 0
    echo "Pass dir name"
    return 1
  end

  set dirname $argv[1]
  mkdir -p $dirname
  eval "cd" $dirname
end
