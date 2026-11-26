#!/bin/bash
# Installs the debug APK on the emulator, launches the app, takes screenshots for ~25s and
# reports whether the app process crashed. Debug build, no signing, no real accounts.
PKG="$1"
mkdir -p shots
adb install -r build/app/outputs/flutter-apk/app-debug.apk || { echo "::error::install failed"; exit 1; }
adb logcat -c
adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
for i in $(seq 1 9); do
  sleep 3
  F=$(adb shell dumpsys window 2>/dev/null | grep -m1 mCurrentFocus | tr -d '\r')
  adb exec-out screencap -p > "shots/launch_$i.png"
  echo "t=$((i*3))s focus=$F pid=$(adb shell pidof "$PKG" | tr -d '\r')"
done
adb logcat -d > shots/logcat.txt 2>/dev/null
CRASH=$(grep -c "FATAL EXCEPTION" shots/logcat.txt)
ALIVE=$(adb shell pidof "$PKG" | tr -d '\r')
echo "FATAL_EXCEPTIONS=$CRASH PROCESS_ALIVE=${ALIVE:+yes}"
grep -A6 "FATAL EXCEPTION" shots/logcat.txt | head -20 | cut -c1-200
for f in $(ls shots/launch_*.png | while read x; do echo "$(md5sum < $x | cut -c1-8) $x"; done | sort -k1,1 -u | awk '{print $2}' | sort | tail -4); do echo "B64_BEGIN $f"; base64 -w0 "$f"; echo; echo "B64_END $f"; done
[ "$CRASH" -eq 0 ] && [ -n "$ALIVE" ]
