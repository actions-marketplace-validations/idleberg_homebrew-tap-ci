# homebrew-tap-ci

GitHub Action for Homebrew taps, following the checks in the [homebrew-core PR template](https://github.com/Homebrew/homebrew-core/blob/main/.github/PULL_REQUEST_TEMPLATE.md). Runs on macOS and Linux.

For every formula or cask changed by a push or pull request:

| Change           | Formula                                                 | Cask (macOS only)              |
| ---------------- | ------------------------------------------------------- | ------------------------------ |
| added or renamed | install from source, `brew test`, `brew audit --new`    | install, `brew audit --new`    |
| modified         | install from source, `brew test`, `brew audit --strict` | install, `brew audit --strict` |

`brew style` always runs on the whole tap. Manual runs (`workflow_dispatch`) audit the whole tap with `--strict` and install nothing.

## Usage

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
    paths: ["Formula/**.rb", "Casks/**.rb"]
  pull_request:
    paths: ["Formula/**.rb", "Casks/**.rb"]
  workflow_dispatch:

jobs:
  ci:
    strategy:
      fail-fast: false
      matrix:
        os: [macos-latest, ubuntu-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: idleberg/homebrew-tap-ci@v1
```

## Testing

[`test/fixtures`](test/fixtures) holds small taps, each with a `base` and a `head` state. The [test workflow](.github/workflows/test.yml) commits both states into a fresh tap, runs the action against the `base` commit and checks the result: `pass` must succeed, `fail` must fail.
