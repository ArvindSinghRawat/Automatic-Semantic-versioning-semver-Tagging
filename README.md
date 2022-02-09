# Git-Automatic-Semver-Tagging

## Introduction

Provides the semantic versioning for the Repo.
Semantic versioning is like `MAJOR`.`MINOR`.`PATCH`.

## Usage [![Latest Release](https://img.shields.io/github/v/release/ArvindSinghRawat/Git-Automatic-Semver-Tagging?color=%233D9970)](https://img.shields.io/github/v/release/ArvindSinghRawat/Git-Automatic-Semver-Tagging?color=%233D9970)

```yml
name: Git Auto Semver Tag

on:
  push:
    branches: [ main ]

jobs:
  auto-tag:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: '0'
    - uses: ArvindSinghRawat/Git-Automatic-Semver-Tagging@main
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
> If this doesn't work, try creating a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) and save it in project's environment with name `PAT` and replace the following code<br/>
      ```
              GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      ```
    <br/>with<br/>
      ```
              GITHUB_TOKEN: ${{ secrets.PAT }}
      ```


### How it works

- If last commit doesn't have any Tag, then proceed with the following steps.
- Checks for the last commit message
- If message for last commit starts with either Breaking or Major (case-insensitive), then increase a Major version (+1.0.0) and reset Minor and Patch versions.
- Otherwise, if message for last commit starts with either Feature or Minor (case-insensitive), then increase a Minor version (+0.1.0) and reset Patch version.
- Otherwise. increase the Patch version only. (+0.0.1)

### Due Credits
Took inspiration from the following sources
- [Stack Overflow: Automatic tagging of releases](https://stackoverflow.com/questions/3760086/automatic-tagging-of-releases)
- [Github Action: Auto Tag Bump](https://github.com/marketplace/actions/auto-tag-bump)
- And the need of this type of versioning for my personal project.
