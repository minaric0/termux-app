# SM-A175N / Android 17 Termux Performance Fork

Branch: `perf/sm-a175n-android17-20261117`.

This fork preserves `com.termux`, native Termux packages, `targetSdkVersion=28`, and the default terminal interface. It is optimized for Samsung SM-A175N (ARM64; reported MediaTek MT6789) running One UI 9.

## Source changes
- PTY bulk reads: 4 KiB -> 16 KiB.
- Output circular queue: 64 KiB -> 128 KiB.
- Atomic coalescing of input-notification Handler posts; 64 KiB bounded drain to avoid monopolizing the UI thread.
- No ANSI output filtering, altered executable paths, or new DNS daemon.

## Build
GitHub Actions > **SM-A175N Termux Performance ARM64** > latest successful run > Artifacts > **SM-A175N-Termux-Perf-arm64-debug**. Select the `arm64-v8a.apk` inside.

**Do not uninstall your existing Termux before backing up.** Package IDs cannot be changed without rebuilding the native package environment. APK signatures from different Termux sources may be incompatible. Debug build is for testing only; use your own controlled release signing key for long-term usage.

## Device settings
- Settings > Apps > Termux > Battery: Unrestricted **if** you run long compiles/background jobs; consumes more battery.
- Developer options > **Disable child process restrictions**: enable only when the OS kills legitimate Termux child processes (e.g. signal 9); this is system-wide and not an execution-speed switch.
- App Compatibility Changes: **leave defaults**; test an individual setting only if you can identify a specific install/runtime failure. A Samsung One UI 9 report mentions policy IDs `2026090201` and `2026010720` but does not establish their meanings; do not disable unknown security policies.
- Background process limit: Standard. Don't keep activities: Off. Forced GPU tweaks: defaults.
- Optional host ADB ART precompile: `adb shell cmd package compile -m speed -f com.termux` (may be unsupported by your build).

## Network performance
You already use Private DNS `one.one.one.one`. Keep it in Android settings and **do not** install a competing local DNS proxy. Cloudflare Private DNS encrypts DNS lookup; it cannot inherently improve TCP throughput or cellular radio speed. If using WARP, measure throughput both on and off. Select the fastest reachable Termux mirror using `termux-change-repo` based on your own tests.

Install `curl`, then run `bash perf/termux-netbench.sh` within Termux to measure DNS/connect/TLS/TTFB/total times for IPv4 versus IPv6. No network or system settings are written by the script.

## Status
Source patch and GitHub Actions workflow added. Physical SM-A175N testing and speed benchmarking still required. Test typing under heavy output, long pastes, Unicode/Korean glyphs, ANSI apps such as vim, process exit, and network transitions.

Sources: 
- https://github.com/termux/termux-packages/wiki/Termux-execution-environment
- https://github.com/termux/termux-app/issues/5297
- https://developer.android.com/guide/app-compatibility/test-debug
- https://developers.cloudflare.com/1.1.1.1/setup/android/
