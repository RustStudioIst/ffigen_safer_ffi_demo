use ::safer_ffi::prelude::*;

mod api;

pub fn add(left: usize, right: usize) -> usize {
    left + right
}

/// A `struct` usable from both Rust and C
#[derive_ReprC]
#[repr(C)]
#[derive(Debug, Clone, Copy)]
pub struct Point {
    x: f64,
    y: f64,
}

/* Export a Rust function to the C world. */
/// Returns the middle point of `[a, b]`.
#[ffi_export]
fn mid_point(a: &Point, b: &Point) -> Point {
    Point {
        x: (a.x + b.x) / 2.,
        y: (a.y + b.y) / 2.,
    }
}

/// Pretty-prints a point using Rust's formatting logic.
#[ffi_export]
fn print_point(point: &Point) {
    println!("{:?}", point);
}

// The following function is only necessary for the header generation.
#[test]
#[cfg(feature = "headers")] // c.f. the `Cargo.toml` section
pub fn generate_headers() -> std::io::Result<()> {
    safer_ffi::headers::builder()
        .to_file("rust_headers.h")?
        .generate()
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        // super::generate_headers().unwrap();
        // let result = add(2, 2);
        // assert_eq!(result, 4);
    }
}
