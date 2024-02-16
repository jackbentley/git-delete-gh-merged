# git-delete-gh-merged

This tool will safely delete local branches that have been merged into the upstream GitHub repo via a PR.

It's mostly useful when collaborating on branches which subsequently get squashed or FF. However, it's indifferent about the merge method used.

Inspired by [not-an-aardvark/git-delete-squashed](https://github.com/not-an-aardvark/git-delete-squashed)

## Requirements

The tool requires `git`, [`gh` cli tool](https://github.com/cli/cli), [`jq`](https://github.com/jqlang/jq).

#### MacOS

```shell
brew install git gh jq
```

## Usage

There's no options. Just run the script.

```shell
./git-delete-gh-merged.sh
```

## How it works

For every branch, a call to the GitHub API will check if there's a corresponding merged PR for the branch.

If it's merged, it will get the head (latest) commit from the PR (the commit containing all the changes in the PR).

Finally, it will check that all the commits in the local branch are present in the PR via `git cherry`.

If all local commits are present in the PR then it will force delete the branch.
