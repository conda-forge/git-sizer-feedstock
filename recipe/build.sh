#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# go one level up
cd "$SRC_DIR"
cd ..

# create the gopath directory structure
export GOPATH=$PWD/gopath
mkdir -p "$GOPATH/src/github.com/github"
ln -s "$SRC_DIR" "$GOPATH/src/github.com/github/git-sizer"
cd "$GOPATH/src/github.com/github/git-sizer"

# build the project
export CGO_ENABLED=0  # disable CGO, as there are no C libs to load
LDFLAGS="-s -w"       # omit the symbol table / debug information and
                      # DWARF symbol table.
go build  -ldflags "${LDFLAGS} -X main.ReleaseVersion=${PKG_VERSION}" .

# install the binary
mkdir -p "$PREFIX/bin"
mv "$GOPATH/../work/git-sizer" "$PREFIX/bin/"