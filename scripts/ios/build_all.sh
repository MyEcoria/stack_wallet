#!/bin/bash

set -e

# libepiccash requires old rust
source ../rust_version.sh
set_rust_to_1671

# ensure ios rust triples are there
rustup target add aarch64-apple-ios
rustup target add x86_64-apple-ios

(cd ../../crypto_plugins/flutter_liblelantus/scripts/ios && ./build_all.sh ) &
(cd ../../crypto_plugins/flutter_libepiccash/scripts/ios && ./build_all.sh )  &
(cd ../../crypto_plugins/flutter_libmonero/scripts/ios/ && ./build_all.sh  ) &

wait
echo "Done building"

# set rust (back) to a more recent stable release to allow stack wallet to build tor
set_rust_to_1720

# ensure ios rust triples are there
rustup target add aarch64-apple-ios
rustup target add x86_64-apple-ios
