#!/usr/bin/env bash
set -euo pipefail

# Check if inside nix chroot
if [ -e /nix ]; then
  echo "ERROR: nix chroot 환경에서는 실행할 수 없습니다." >&2
  exit 1
fi

KILL=false
while getopts "k" opt; do
  case "$opt" in
    k) KILL=true ;;
    *) echo "Usage: $0 [-k]" >&2; exit 1 ;;
  esac
done

# Find dbus-daemon PIDs whose cwd contains "godinus"
PIDS=()
for p in $(ps -C dbus-daemon h -o pid 2>/dev/null); do
  cwd=$(readlink "/proc/$p/cwd" 2>/dev/null || true)
  if [[ "$cwd" == *godinus* ]]; then
    PIDS+=("$p")
    echo "PID $p - $cwd"
  fi
done

if [ ${#PIDS[@]} -eq 0 ]; then
  echo "godinus 관련 dbus-daemon 프로세스가 없습니다."
  exit 0
fi

if [ "$KILL" = true ]; then
  kill "${PIDS[@]}"
  echo "Killed ${#PIDS[@]} process(es): ${PIDS[*]}"
else
  read -rp "위 ${#PIDS[@]}개 프로세스를 kill 하시겠습니까? [y/N] " answer
  if [[ "$answer" =~ ^[yY]$ ]]; then
    kill "${PIDS[@]}"
    echo "Killed ${#PIDS[@]} process(es): ${PIDS[*]}"
  else
    echo "취소됨."
  fi
fi
