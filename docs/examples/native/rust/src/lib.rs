// src/lib.rs
// Rust bare-metal ABI module for Nicy: nativeAdd(a, b).
//
// Entry point: pub unsafe extern "C-unwind" fn nicydinamic_init(l: *mut LuauState) -> c_int
// Note: The function name must be exactly "nicydinamic_init" or "nicydynamic_init"

use core::ffi::c_int;

#[repr(C)]
pub struct LuauState {
    _private: [u8; 0],
}

pub type LuaInteger = i64;
pub type LuaCFunction = unsafe extern "C-unwind" fn(*mut LuauState) -> c_int;

// Nicy Luau API bindings
unsafe extern "C-unwind" {
    fn nicy_luaL_checkinteger(l: *mut LuauState, narg: c_int) -> LuaInteger;
    fn nicy_lua_pushinteger(l: *mut LuauState, n: LuaInteger);
    fn nicy_lua_pushcfunction(l: *mut LuauState, f: LuaCFunction);
    fn nicy_lua_setglobal(l: *mut LuauState, k: *const c_char);
    fn nicy_lua_createtable(l: *mut LuauState, narr: c_int, nrec: c_int);
}

// Native function: nativeAdd(a, b) -> a + b
unsafe extern "C-unwind" fn native_add(l: *mut LuauState) -> c_int {
    // Read validated integer arguments from stack (1-indexed)
    let a = unsafe { nicy_luaL_checkinteger(l, 1) };
    let b = unsafe { nicy_luaL_checkinteger(l, 2) };

    // Push single return value
    unsafe { nicy_lua_pushinteger(l, a + b) };
    1
}

// Module entry point - called by nicyrtdyn when loading the module
#[unsafe(no_mangle)]
pub unsafe extern "C-unwind" fn nicydinamic_init(l: *mut LuauState) -> c_int {
    // Create a table for module exports (optional - can also use globals)
    unsafe { nicy_lua_createtable(l, 0, 1) };

    // Register native_add function
    unsafe { nicy_lua_pushcfunction(l, native_add) };
    unsafe { nicy_lua_setglobal(l, b"nativeAdd\0".as_ptr() as *const c_char) };

    // Return 1 (the module table on stack)
    1
}
