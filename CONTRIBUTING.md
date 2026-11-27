# Contributing

We are happy to accept any contributions that make sense and respect the rules listed below.

## How to contribute

1. Fork the repo.
2. Create a feature branch for your contribution out of the `master` branch. Only one contribution per branch is accepted.
3. Implement your contribution while respecting our rules (see below).
4. Run `npm run lint`, `npm run compile` and `npm test` to make sure you didn't break anything. CI runs all three on every pull request.
5. Add tests for your contribution so that no one else will break it.
6. Submit a pull request against our `master` branch!

## Rules

* **Do** use feature branches.
* **Do** conform to existing coding style so that your contribution fits in.
* **Do** use [EditorConfig] to enforce our [whitespace rules](.editorconfig). If your editor is not supported, enforce the settings manually.
* **Do** run `npm run lint` for ESLint and Prettier, and `npm test` for unit test coverage. The tests load the compiled JavaScript, so run `npm run compile` first.
* **Do not** touch the `version` field in [package.json](package.json).
* **Do not** commit any generated files, unless already in the repo. If absolutely necessary, explain why.
* **Do not** create any top level files or directories. If absolutely necessary, explain why and update the `files` list in [package.json](package.json).

## Releasing

Releases are cut with GitHub Actions:

1. Run the `Prepare release` workflow on `master` with the new version. It bumps `package.json`, adds the release notes to [CHANGELOG.md](CHANGELOG.md) and pushes a `release/v<version>` branch.
2. Open a pull request for that branch, label it `ignore-for-release` and merge it once the checks pass.
3. Run the `Release` workflow on `master` with the same version. It tags the release, creates the GitHub release and publishes to npm with trusted publishing.

## License

By contributing your code, you agree to license your contribution under our [LICENSE](LICENSE).

[editorconfig]: <http://editorconfig.org/>
