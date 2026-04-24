# TaimiHUD data sources

This is a repository to be used for requests to list data sources for TaimiHUD.

## Template examples

The quickest way to get a pack added is to submit a pull request, here are some examples of how to format the data:

* af73d6ad4bfd5d261487f04dca4471a814c4b36a
  [Pathing packs are typically hosted by GitHub releases](https://github.com/TaimiHUD/DataSources/commit/af73d6ad4bfd5d261487f04dca4471a814c4b36a).
* daa06eca841413f1d62f4b5e5053437577d89351
  [Direct download URL for TacO pack](https://github.com/TaimiHUD/DataSources/commit/daa06eca841413f1d62f4b5e5053437577d89351).
* [./timers/config.nix](timers) and [./markers/config.nix](markers) are configured in their own respective files.
* hashes can be generated using `nix hash file --sri` or similar, but it's fine to just leave a placeholder: `hash = null;`

Once merged, we'll tag it to be deployed to the addon automatically from there.

## Manual Requests

A request can also be made through any [contact method](https://taimihud.com/faq/#help).
You may submit the request and relevant info to the [#share-your-packs](https://discord.com/channels/1385422230741323836/1466603641132683460) channel on Discord.

## Updating

(this isn't necessary in order to generate sources.toml to be consumed by TaimiHUD so can be ignored for now)

This should be automated by CI, but some of the manual process will be described here.

```bash
nix build -L .#allUpdateChecks
```
