# Standar version

Add [Standar version][sc] incredibly fast into your project!

## Features

- Allow prerelease
- Super easy to setup
- Automatically bump version
- Automatically create changelog
- Update package.json your repo with the new version

Are you using [conventional commits][cc] and [semver][semver]?

Then you are ready to use this github action.

## Usage

1. Follow the Conventional Commits Specification in your repository.
2. Create a `.github/workflows/bumpversion.yaml` with the Sample Workflow

## Sample Workflow

```yaml
name: Bump version

on:
  push:
    branches:
      - master

jobs:
  bump_version:
    if: "!startsWith(github.event.head_commit.message, 'bump:')"
    runs-on: ubuntu-latest
    name: "Bump version and create changelog with commitizen"
    steps:
      - name: Check out
        uses: actions/checkout@v2
        with:
          fetch-depth: 0
          token: "${{ secrets.GITHUB_TOKEN }}"
      - name: Create bump and changelog
        uses: Sha-code/standard-version_action@1.0.7
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

## Variables

| Name           | Description                                                                           | Default     |
| -------------- | ------------------------------------------------------------------------------------- | ----------- |
| `github_token` | Token for the repo. Can be passed in using `${{ secrets.GITHUB_TOKEN }}` **required** | -           |
| `dry_run`      | Run without creating commit, output to stdout                                         | false       |
| `repository`   | Repository name to push. Default or empty value represents current github repository  | current one |
| `branch`       | Destination branch to push changes                                                    | `master`    |
| `prerelease`   | Set as prerelease {alpha,beta,rc} choose type of prerelease                           | -           |

<!--           | `changelog`                                                                                                  | Create changelog when bumping the version | true | -->

## Troubleshooting

### Other actions are not triggered when the tag is pushed

This problem occurs because `secrets.GITHUB_TOKEN` does not trigger other
actions [by design][by_design].

To solve it you must use a personal access token in the checkout and the commitizen steps.

Follow the instructions in [commitizen's documentation][cz-docs-ga]

## I'm not using conventional commits, I'm using my own set of rules on commits

The only way to use this is to switch to the standard :

[Read more about standard][cc]

[by_design]: https://docs.github.com/en/free-pro-team@latest/actions/reference/events-that-trigger-workflows#example-using-multiple-events-with-activity-types-or-configuration
[sc]: https://www.npmjs.com/package/standard-version
[cc]: https://www.conventionalcommits.org/
[semver]: https://semver.org/
