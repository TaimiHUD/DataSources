{ runCommand
, curl, jq
, lib
, sourceInfo ? { lastModified = 0; }
, impure ? toString builtins.currentTime or sourceInfo.lastModified
}: {
  pname
, refName
, owner
, repo
, outputHashAlgo ? "sha256"
}: runCommand "${pname}-check-${refName}" {
  inherit pname outputHashAlgo impure refName owner repo;
  outputHash = builtins.hashString outputHashAlgo "${pname}!${refName}!${impure}\n";
  outputHashMode = "flat";
  preferLocalBuild = true;
  allowSubstitutes = false;
  impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [ "NIX_CURL_FLAGS" "NIX_GITHUB_TOKEN" "CI_GITHUB_TOKEN" ];
  ghTokenEval = builtins.getEnv "CI_GITHUB_TOKEN";
  nativeBuildInputs = [ curl jq ];
  #queryRelease = "sort_by(.tag_name) | [.[]|select(.prerelease==false and .draft==false)] | .[-1].tag_name";
  queryTag = "sort_by(.name) | .[-1].name";
  queryReleaseLatest = ".tag_name";
  meta.displayName = "${pname} ${refName} outdated";
} ''
  #RELEASE_URL="https://api.github.com/repos/$owner/$repo/releases"
  RELEASE_URL="https://api.github.com/repos/$owner/$repo/releases/latest"
  TAGS_URL="https://api.github.com/repos/$owner/$repo/tags"
  GH_CURL_FLAGS=(
    --insecure
    --location-trusted
    -fSsL
    -H "X-GitHub-Api-Version: 2022-11-28"
    $NIX_CURL_FLAGS
  )
  if [[ -z ''${NIX_GITHUB_TOKEN:-} ]]; then
    NIX_GITHUB_TOKEN=''${CI_GITHUB_TOKEN:-''${ghTokenEval-}}
  fi
  if [[ -n ''${NIX_GITHUB_TOKEN-} ]]; then
    GH_CURL_FLAGS+=(
      -H "Authorization: $NIX_GITHUB_TOKEN"
    )
  fi
  if REPO_RELEASES=$(curl \
    "''${GH_CURL_FLAGS[@]}" \
    "$RELEASE_URL"
  ); then
    REPO_LATEST=$(jq -r "$queryReleaseLatest" - <<< "$REPO_RELEASES")
  elif REPO_TAGS=$(curl \
    "''${GH_CURL_FLAGS[@]}" \
    "$TAGS_URL"
  ); then
    REPO_LATEST=$(jq -r "$queryTag" - <<< "$REPO_TAGS")
  else
    echo failed to query latest release >&2
    return 1
  fi
  if [[ $REPO_LATEST = $refName ]]; then
    echo "$pname-$refName up-to-date" >&2
  else
    echo "$pname-$refName out of date, found version $REPO_LATEST" >&2
  fi
  printf '%s!%s!%s\n' "$pname" "$REPO_LATEST" "$impure" > $out
''
