# Build the iOS .a
# 输出目录在 target/aarch64-apple-ios/release
cargo lipo --targets aarch64-apple-ios --release
echo "output: target/aarch64-apple-ios/release"