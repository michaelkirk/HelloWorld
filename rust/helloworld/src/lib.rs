uniffi::setup_scaffolding!();

#[uniffi::export]
pub fn hello_world() -> String {
    "Hello, World!".to_string()
}
