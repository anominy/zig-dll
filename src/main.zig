const std = @import("std");
const uni = std.unicode;
const win = std.os.windows;
const k32 = std.os.windows.kernel32;

const DLL_PROCESS_ATTACH: win.DWORD = 1;
const DLL_PROCESS_DETACH: win.DWORD = 0;
const DLL_THREAD_ATTACH: win.DWORD = 2;
const DLL_THREAD_DETACH: win.DWORD = 3;

extern "kernel32" fn GetConsoleWindow() callconv(.winapi) win.BOOL;
extern "kernel32" fn AllocConsole() callconv(.winapi) win.BOOL;
extern "kernel32" fn SetConsoleTitleW(title: [*]const u16) callconv(.winapi) win.BOOL;

pub fn DllMain(
    instance: win.HINSTANCE,
    reason: win.DWORD,
    reserved: win.LPVOID
) callconv(.winapi) win.BOOL {
    _ = instance;
    _ = reserved;

    if (reason == DLL_PROCESS_DETACH
            or reason == DLL_THREAD_ATTACH
            or reason == DLL_THREAD_DETACH) {
        return win.TRUE;
    }

    const console = GetConsoleWindow();
    if (console == 0 and AllocConsole() == 0) {
        return win.FALSE;
    }
    const title = uni.utf8ToUtf16LeStringLiteral("Command Prompt");
    var isSuccess = SetConsoleTitleW(title);
    if (isSuccess == 0) {
        return win.FALSE;
    }

    const stdout = win.GetStdHandle(win.STD_OUTPUT_HANDLE)
        catch return win.FALSE;

    const message = uni.utf8ToUtf16LeStringLiteral("Hey, Cutie! ^^\n");
    isSuccess = k32.WriteConsoleW(stdout, message, message.len, null, null);
    if (isSuccess == 0) {
        return win.FALSE;
    }

    return win.TRUE;
}
