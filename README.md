# TaimiHUD data sources

This is a repository to be used for requests to list data sources for TaimiHUD.

## Template samples

The quickest way to get a pack added is to submit a pull request, here are some examples of how to format the data:

* Pathing packs are typically hosted by GitHub releases:
  [example `af73d6a`](https://github.com/TaimiHUD/DataSources/commit/af73d6ad4bfd5d261487f04dca4471a814c4b36a#diff-content-parent).
* Direct download URL of a TacO pack:
  [example `daa06ec`](https://github.com/TaimiHUD/DataSources/commit/daa06eca841413f1d62f4b5e5053437577d89351#diff-content-parent).
* [Combat timers](./timers/config.nix) and [squad markers](./markers/config.nix) are configured similarly from their own respective files.
* Hashes can be generated using `nix hash file --sri`, but it's fine to just leave a placeholder: `hash = null;`

Once accepted, we'll tag it to be deployed to the addon automatically from there.

## Manual Requests

Submit a new issue here or otherwise make a request through any [contact method](https://taimihud.com/faq/#help).
You may submit the request and relevant info to the [#share-your-packs](https://discord.com/channels/1385422230741323836/1466603641132683460) channel on Discord.

## Updating

(this isn't necessary in order to generate sources.toml to be consumed by TaimiHUD so can be ignored for now)

This should be automated by CI, but some of the manual process will be described here.

```bash
nix build -L .#allUpdateChecks
```
