# homebrew-tap-ci

GitHub Action for Homebrew taps, following the checks in the [homebrew-core PR template](https://github.com/Homebrew/homebrew-core/blob/main/.github/PULL_REQUEST_TEMPLATE.md). Runs on macOS and Linux.

For every formula or cask changed by a push or pull request:

| Formula                                                 | Cask (macOS only)              |
| ------------------------------------------------------- | ------------------------------ |
| install from source, `brew test`, `brew audit --strict` | install, `brew audit --strict` |

There's no `--new` audit: its notability and signing checks are meant for Homebrew's official taps.

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

### Inputs

| Input            | Default                                 | Description                                                                                                     |
| ---------------- | --------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `setup-homebrew` | `true`                                  | Set up the latest Homebrew release and tap the checked-out repository. Set to `false` if your job already does. |
| `tap`            | current repository                      | Tap to check, as `user/repo`. The `homebrew-` prefix is optional.                                               |
| `base`           | pull request base, or previous push tip | Commit to compare against. Empty audits the whole tap and installs nothing.                                     |
| `token`          | `github.token`                          | GitHub token passed to `setup-homebrew`.                                                                        |

### Outputs

| Output   | Description                                                                                 |
| -------- | ------------------------------------------------------------------------------------------- |
| `failed` | Failed packages with the stage they failed at, comma-separated, e.g. `user/tap/foo (test)`. |

## Testing

[`test/fixtures`](test/fixtures) holds small taps, each with a `base` and a `head` state. The [test workflow](.github/workflows/test.yml) commits both states into a local tap, runs the action against the `base` commit and checks both the outcome and the `failed` output: `pass` must succeed with nothing failed, `fail` must fail only on `hello-broken`'s `brew test`.
