# Automatic Semantic versioning(SemVer) Tagging

## Introduction

Automatically provides the semantic versioning as Tags for a Github repository.
Semantic versioning is like `MAJOR`.`MINOR`.`PATCH`.

Benefits of SemVer tags:
- **Predictability**: SemVer gives devs a way to understand the impact of updating a dependency. They can tell at a glance whether an update includes major changes, new features or just bug fixes.
- **Release or Upgrade planning**: SemVer can help users of a library or an API to understand when and how they need to update their own code to stay compatible. Eg: If their is a major change, it needs to more time and work to accomodate as opposed to a patch change.
- **Communication**: SemVer clearly communicates what kind of changes were made in each release. It also assists in supporting backward compatibility. 



## Usage [![Latest Release](https://img.shields.io/github/v/release/ArvindSinghRawat/Automatic-Semantic-versioning-semver-Tagging?color=%233D9970)](https://img.shields.io/github/v/release/ArvindSinghRawat/Automatic-Semantic-versioning-semver-Tagging?color=%233D9970)

```yml
name: Git Auto Semver Tag

on:
  push:
    branches: [ main ]

permissions:
  contents: write

jobs:
  auto-tag:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
      with:
        fetch-depth: 0
        fetch-tags: true
        set-safe-directory: true
        
    - uses: ArvindSinghRawat/Automatic-Semantic-versioning-semver-Tagging@main
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
