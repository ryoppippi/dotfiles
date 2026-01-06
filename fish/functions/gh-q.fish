set GH_Q_DEFAULT_USER ""

function gh-q
    if test -z $GH_Q_DEFAULT_USER
        set GH_Q_DEFAULT_USER (gh api user -q .login)
    end

    set -l query (string trim "
query (\$owner: String!, \$endCursor: String) {
  repositoryOwner(login: \$owner) {
    repositories(
      first: 30
      after: \$endCursor
    ){
      pageInfo {
        hasNextPage
        endCursor
      }
      nodes {
        nameWithOwner
      }
    }
  }
} " )

    set -l REPO (gh api graphql \
      --paginate \
      --field owner=$GH_Q_DEFAULT_USER \
      -f query="$query" \
      --jq '.data.repositoryOwner.repositories.nodes[].nameWithOwner' \
    | fzf)

    if test -z $REPO
        return
    end

    ghq get $REPO

    cd (ghq root)/github.com/$REPO
end
