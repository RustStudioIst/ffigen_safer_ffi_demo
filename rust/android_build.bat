@echo off
rem Build the Android .so
rem 输出目录在 ./jniLibs
cargo ndk -t armeabi-v7a -t arm64-v8a -o ./jniLibs build --release