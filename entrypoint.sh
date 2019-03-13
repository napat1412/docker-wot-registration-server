#!/bin/bash
set -x -e
ROOT_DIR=/home/user
pdns_server --config-dir=$ROOT_DIR/config &
RUST_LOG=registration_server=debug,maxminddb=info $ROOT_DIR/target/release/main --config-file=$ROOT_DIR/config/config.toml
