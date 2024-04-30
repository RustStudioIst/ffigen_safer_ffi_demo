use std::{env, path::{Path, PathBuf}};

/// 如果希望在控制台看到输出的信息，可以使用println!宏
/// 并使用`cargo build -vv` `-vv`参数, 才能看到输出的信息, 否则被隐藏
fn main() {
    let target = env::var("CARGO_CFG_TARGET_OS").unwrap();
    println!("Running custom build script! target: {}", target);
    if target == "android" {
        //android();
    }
}

fn android() {
    println!("cargo:rustc-link-lib=c++_shared");

    if let Ok(output_path) = env::var("CARGO_NDK_OUTPUT_PATH") {
        let sysroot_libs_path =
            PathBuf::from(env::var_os("CARGO_NDK_SYSROOT_LIBS_PATH").unwrap());
        let lib_path = sysroot_libs_path.join("libc++_shared.so");
        std::fs::copy(
            lib_path,
            Path::new(&output_path)
                .join(&env::var("CARGO_NDK_ANDROID_TARGET").unwrap())
                .join("libc++_shared.so"),
        )
            .unwrap();
    }
}