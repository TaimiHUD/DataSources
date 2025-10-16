# TaimiHUD data sources

This is a repository to be used for requests to list data sources for TaimiHUD.

## Updating

(this isn't necessary in order to generate sources.toml to be consumed by TaimiHUD so can be ignored for now)

This should be automated by CI, but some of the manual process will be described here.

```bash
nix build -L .#allUpdateChecks
```
