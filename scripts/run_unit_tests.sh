#!/usr/bin/env bash
# 在工程根目录执行：./scripts/run_unit_tests.sh
# 跑全部测试（单元 + UI）：./scripts/run_all_tests.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f "SDAutoLayoutDemo.xcworkspace/contents.xcworkspacedata" ]]; then
  echo "请先执行: pod install"
  exit 1
fi

if [[ ! -f "Pods/Target Support Files/Pods-SDAutoLayoutDemoTests/Pods-SDAutoLayoutDemoTests.debug.xcconfig" ]]; then
  echo "缺少 Pods-SDAutoLayoutDemoTests 配置，请执行: pod install"
  exit 1
fi

DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 17,OS=26.5}"

echo "==> xcodebuild test (SDAutoLayoutDemoTests @ ${DESTINATION})"
xcodebuild test \
  -workspace SDAutoLayoutDemo.xcworkspace \
  -scheme SDAutoLayoutDemo \
  -destination "$DESTINATION" \
  -only-testing:SDAutoLayoutDemoTests \
  CODE_SIGNING_ALLOWED=NO

echo "单元测试通过。"
