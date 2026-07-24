#!/bin/bash
# Produces libemf2svg.tar.gz as a source-only tarball.
#
# What's included:
#   libemf2svg/            <- top dir (matches historical v1.7.3 shape)
#     CMakeLists.txt
#     vcpkg.json           <- manifest (consumers bootstrap vcpkg themselves)
#     src/, inc/, tests/, goodies/, cmake/
#     vendor/argp-standalone, vendor/fmem, vendor/libuemf   <- tracked source
#     .gitmodules, README.md, LICENSE, ...
#
# What's NOT included:
#   - vcpkg/ submodule contents (consumers bootstrap vcpkg at build time)
#   - .git, .github
#   - build artifacts (build/, deps/, vcpkg_installed/, cache/)
#
# Implementation: git archive produces tracked files only. Submodule
# contents (vcpkg/) are excluded by design -- they live in a separate
# git object database. vendor/* dirs are tracked as plain files and
# are included.

set -euo pipefail

OUTPUT_DIR="${1:-$(pwd)}"
TARBALL="$OUTPUT_DIR/libemf2svg.tar.gz"

git archive --format=tar.gz --prefix=libemf2svg/ -o "$TARBALL" HEAD

sha256sum "$TARBALL" | awk '{print $1}' > "$TARBALL.sha256"

echo "Created $TARBALL ($(du -h "$TARBALL" | awk '{print $1}'))"
echo "SHA256: $(cat "$TARBALL.sha256")"
