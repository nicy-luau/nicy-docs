// src/lib.rs
// Rust bare-metal ABI module for Nicy: nativeAdd(a, b).

use core::ffi::c_char;
use std::ffi::CString;

#[repr(C)]
pub struct LuauState {
    _private: [u8; 0],
}

pub type LuaInteger = i64;
pub type LuaCFunction = unsafe extern "C" fn(*mut LuauState) -> i32;

unsafe extern "C" {
    fn nicy_luaL_checkinteger(l: *mut LuauState, narg: i32) -> LuaInteger;
    fn nicy_lua_pushinteger(l: *mut LuauState, n: LuaInteger);
    fn nicy_lua_pushcfunction(l: *mut LuauState, f: LuaCFunction);
    fn nicy_lua_setglobal(l: *mut LuauState, k: *const c_char);
}

unsafe extern "C" fn native_add(l: *mut LuauState) -> i32 {
    // Read validated integer arguments.
    let a = nicy_luaL_checkinteger(l, 1);
    let b = nicy_luaL_checkinteger(l, 2);

    // Push single return value.
    nicy_lua_pushinteger(l, a + b);
    1
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn nicy_module_init(l: *mut LuauState) {
    let name = CString::new("nativeAdd").unwrap();
    nicy_lua_pushcfunction(l, native_add);
    nicy_lua_setglobal(l, name.as_ptr());
}
