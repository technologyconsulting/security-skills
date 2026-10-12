#!/usr/bin/env bash
# Session-start check: is a newer security-skills on the marketplace?
#
# Reads the installed version from this plugin's manifest, fetches the
# marketplace manifest from GitHub at most once a day (cached under
# ~/.cache/security-skills), and prints one line when a newer version exists.
# Prints nothing when up to date, offline, or on any error. Never fails the
# session: every path exits 0.
#
#   check-version.sh            one line if an update exists, else nothing
#   check-version.sh --status   always prints installed and latest versions
#   check-version.sh --fresh    ignore the cache

set -u

ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
MANIFEST="$ROOT/.claude-plugin/plugin.json"
SOURCE="${SECURITY_SKILLS_SOURCE:-https://raw.githubusercontent.com/technologyconsulting/security-skills/main/.claude-plugin/plugin.json}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/security-skills"
CACHE="$CACHE_DIR/latest-version"
MAX_AGE=86400

mode="${1:-}"

version_of() {
  # First "version" key in a small JSON file, no jq dependency.
  sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$1" 2>/dev/null | head -1
}

installed="$(version_of "$MANIFEST")"
[ -n "$installed" ] || exit 0

latest=""
if [ "$mode" != "--fresh" ] && [ -f "$CACHE" ]; then
  now=$(date +%s)
  mtime=$(stat -f %m "$CACHE" 2>/dev/null || stat -c %Y "$CACHE" 2>/dev/null || echo 0)
  if [ $((now - mtime)) -lt "$MAX_AGE" ]; then
    latest="$(cat "$CACHE" 2>/dev/null)"
  fi
fi

if [ -z "$latest" ]; then
  tmp="$(mktemp 2>/dev/null || echo /tmp/security-skills-version.$$)"
  if curl -fsSL --max-time 3 "$SOURCE" -o "$tmp" 2>/dev/null; then
    latest="$(version_of "$tmp")"
    if [ -n "$latest" ]; then
      mkdir -p "$CACHE_DIR" 2>/dev/null && printf '%s\n' "$latest" > "$CACHE" 2>/dev/null
    fi
  fi
  rm -f "$tmp"
fi

newer=0
if [ -n "$latest" ] && [ "$latest" != "$installed" ]; then
  # Newer when the installed version does not sort last.
  top="$(printf '%s\n%s\n' "$installed" "$latest" | sort -V | tail -1)"
  [ "$top" = "$latest" ] && newer=1
fi

if [ "$mode" = "--status" ]; then
  printf 'installed=%s latest=%s update=%s\n' "$installed" "${latest:-unknown}" "$newer"
  exit 0
fi

if [ "$newer" = 1 ]; then
  printf 'security-skills %s is installed and %s is available. Run /upgrade-security-skills to update; it reads the changelog and does the repo-side steps. Changelog: https://github.com/technologyconsulting/security-skills/blob/main/CHANGELOG.md\n' "$installed" "$latest"
fi
exit 0
