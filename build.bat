@zig build-lib -O ReleaseSmall -dynamic "%~dp0src/main.zig"
@md "%~dp0out" 2>nul
@move /y .\main.dll "%~dp0out" 1>nul
@move /y .\main.lib "%~dp0out" 1>nul
