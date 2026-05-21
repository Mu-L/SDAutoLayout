#!/usr/bin/env bash
# 在工程根目录执行：./scripts/run_all_tests.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f "SDAutoLayoutDemo.xcworkspace/contents.xcworkspacedata" ]]; then
  echo "请先执行: pod install"
  exit 1
fi

DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 17,OS=26.5}"

echo "==> xcodebuild test (unit + UI @ ${DESTINATION})"
xcodebuild test \
  -workspace SDAutoLayoutDemo.xcworkspace \
  -scheme SDAutoLayoutDemo \
  -destination "$DESTINATION" \
  CODE_SIGNING_ALLOWED=NO

echo "全部测试通过。"
