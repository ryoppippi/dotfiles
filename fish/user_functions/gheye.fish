function gheye
    set -l repo $argv[1]
    curl -s https://ungh.cc/repos/$repo/readme | jq -r .markdown | glow
end
