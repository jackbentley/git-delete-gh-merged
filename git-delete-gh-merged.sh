#!/bin/bash

git fetch -p

git for-each-ref refs/heads/ "--format=%(refname:short)" | while read -r branch; do
    printf "%b%s%b\n" "\e[1m" "$branch" "\e[0m"

    resp=$(gh pr view "$branch" --json headRefOid,mergedAt 2>/dev/null)
    headRefOid=$(jq -r '.headRefOid // empty' <<< ${resp})
    mergedAt=$(jq -r '.mergedAt // empty' <<< ${resp})

    oMerged="\e[31m"
    oPushed="\e[90m"

    if [ -n "${mergedAt}" ]; then
        oMerged="\e[92m"
        oPushed="\e[31m"

        git fetch origin "$headRefOid" &>/dev/null
        unPushedCommits=$(git cherry "$headRefOid" "$branch" -v | grep '^+')

        printf "%b" "\e[90m"
        if [ -z "${unPushedCommits}" ]; then
            oPushed="\e[92m"
            git branch -D "$branch"
        else
            echo "$unPushedCommits"
        fi
        printf "%b" "\e[0m"
    fi

    if [ -n "${headRefOid}" ]; then
        printf "%b%s %b%s%b\n\n" "$oMerged" "merged" "$oPushed" "pushed" "\e[0m"
    else
        printf "%b%s%b\n\n" "\e[90m" "no pr" "\e[0m"
    fi
done
