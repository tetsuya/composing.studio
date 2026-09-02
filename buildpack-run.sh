#!/bin/bash
set -e

# wasm-pack binary: pin a version and cache the download
WASM_PACK_VERSION=0.13.1
WASM_PACK_DIR="$CACHE_DIR/wasm-pack/$WASM_PACK_VERSION"

if [ ! -x "$WASM_PACK_DIR/wasm-pack" ]; then
  echo "Downloading wasm-pack v$WASM_PACK_VERSION"
  mkdir -p "$WASM_PACK_DIR"
  curl -sSfL "https://github.com/rustwasm/wasm-pack/releases/download/v${WASM_PACK_VERSION}/wasm-pack-v${WASM_PACK_VERSION}-x86_64-unknown-linux-musl.tar.gz" \
    | tar xz -C "$WASM_PACK_DIR" --strip-components=1
else
  echo "Using cached wasm-pack v$WASM_PACK_VERSION"
fi
export PATH="$WASM_PACK_DIR:$PATH"

# wasm build artifacts: keep cargo's incremental output between builds
export CARGO_TARGET_DIR="$CACHE_DIR/wasm-target"

rustup target add wasm32-unknown-unknown

cd "$BUILD_DIR"
wasm-pack build --target web cstudio-wasm
