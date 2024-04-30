use safer_ffi::ffi_export;

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/04/30
///

/// 测试输入一个字符串, 返回对应的字符串
#[ffi_export]
fn test_string(str: &safer_ffi::String) -> safer_ffi::String {
    format!("Hello, {}", str).into()
}

/// 测试输入一个字节数组, 返回对应的字节长度
#[ffi_export]
fn test_bytes(bytes: &safer_ffi::Vec<u8>) -> usize {
    bytes.len()
}