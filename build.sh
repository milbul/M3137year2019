#!/usr/bin/env bash

function compile {
    echo "Building" "$1"
    cd "$(dirname "$1")"
    # for _ in {1..20}; do latexmk -f -xelatex -shell-escape "$(basename "$1")" &> /dev/null; done
    for _ in {1..20}; do
    cat /dev/null > "$REPOPATH"/latex.log
    if ! latexmk -pdf -xelatex -interaction=nonstopmode -shell-escape "$(basename "$1")" &> "$REPOPATH"/latex.log; then
        status="OK"
        status="FAILED"
    fi
    [ "$status" == "FAILED" ] && cat "$REPOPATH"/latex.log && exit 1
    done
    cd "$REPOPATH"
}

REPOPATH=$(pwd)

while IFS= read -r -d '' fname
do
    compile "$fname"
done <   <(find . \( -wholename "*/5sem/main.tex" -o -wholename "*/5sem/final.tex" -o -wholename "*/5sem/*/*.tex" \) -type f -print0)

# while IFS= read -r -d '' file
# do
#     compile "$file"
# done <   <(git diff --name-only HEAD "$(git show 'HEAD^{/^Built pdfs}' --pretty=format:"%h" --no-patch || git rev-list --max-parents=0 HEAD)" | grep "\.tex" | tr '\n' '\0')
