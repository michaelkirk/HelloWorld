#!/usr/bin/env zsh

set -e
set -u

fat_simulator_lib_dir="target/ios-simulator-fat/release"

generate_ffi() {
  echo "Generating framework module mapping and FFI bindings"
  cargo run -p uniffi-bindgen-swift -- target/aarch64-apple-ios/release/lib$1.a target/uniffi-xcframework-staging --swift-sources --headers --modulemap --module-name $1FFI --modulemap-filename module.modulemap
  mkdir -p ../Sources/HelloWorldFFI/
  mv target/uniffi-xcframework-staging/*.swift ../Sources/HelloWorldFFI/
}

create_fat_simulator_lib() {
  echo "Creating a fat library for x86_64 and aarch64 simulators"
  mkdir -p $fat_simulator_lib_dir
  lipo -create target/x86_64-apple-ios/release/lib$1.a target/aarch64-apple-ios-sim/release/lib$1.a -output $fat_simulator_lib_dir/lib$1.a
}

build_xcframework() {
  echo "Generating XCFramework"
  rm -rf target/ios
  xcodebuild -create-xcframework \
    -library target/aarch64-apple-ios/release/lib$1.a -headers target/uniffi-xcframework-staging \
    -library target/ios-simulator-fat/release/lib$1.a -headers target/uniffi-xcframework-staging \
    -output target/ios/lib$1-rs.xcframework
}

basename=helloworld

echo "Building for iOS"
cargo build -p $basename --lib --release --target aarch64-apple-ios
cargo build -p $basename --lib --release --target aarch64-apple-ios-sim
cargo build -p $basename --lib --release --target x86_64-apple-ios

generate_ffi $basename
create_fat_simulator_lib $basename
build_xcframework $basename

echo "Done! XCFramework at target/ios/lib$basename-rs.xcframework"
