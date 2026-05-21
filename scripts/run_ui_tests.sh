#!/usr/bin/env bash
# 在工程根目录执行：./scripts/run_ui_tests.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f "SDAutoLayoutDemo.xcworkspace/contents.xcworkspacedata" ]]; then
  echo "请先执行: pod install"
  exit 1
fi

DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 17,OS=26.5}"

echo "==> xcodebuild test (SDAutoLayoutDemoUITests @ ${DESTINATION})"
xcodebuild test \
  -workspace SDAutoLayoutDemo.xcworkspace \
  -scheme SDAutoLayoutDemo \
  -destination "$DESTINATION" \
  -only-testing:SDAutoLayoutDemoUITests \
  CODE_SIGNING_ALLOWED=NO

echo "UI 测试通过。"
