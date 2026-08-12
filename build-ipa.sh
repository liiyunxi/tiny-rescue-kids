#!/bin/bash
# ============================================
# 狗狗救援队 - 一键打包 .ipa 脚本
# 运行环境：macOS + Xcode 15+（Windows 无法打包 iOS 应用）
# 用法：chmod +x build-ipa.sh && ./build-ipa.sh
# ============================================
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

SCHEME="TinyRescueKids"
ARCHIVE_PATH="build/TinyRescueKids.xcarchive"
EXPORT_PATH="build/ipa"

echo "==> 1/4 生成 Xcode 工程（XcodeGen）"
if ! command -v xcodegen &> /dev/null; then
    echo "未检测到 xcodegen，正在通过 Homebrew 安装..."
    brew install xcodegen
fi
xcodegen generate

echo "==> 2/4 清理旧构建"
rm -rf build
mkdir -p build

echo "==> 3/4 编译归档（Archive）"
# 注意：首次运行前，请先在 Xcode 里打开工程，
# Signing & Capabilities 中选择你的 Team（免费 Apple ID 即可）
xcodebuild archive \
    -scheme "$SCHEME" \
    -destination "generic/platform=iOS" \
    -archivePath "$ARCHIVE_PATH" \
    -configuration Release \
    -allowProvisioningUpdates

echo "==> 4/4 导出 .ipa"
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_PATH" \
    -exportOptionsPlist ExportOptions.plist \
    -allowProvisioningUpdates

echo ""
echo "✅ 打包完成！ipa 文件位置："
ls -lh "$EXPORT_PATH"/*.ipa
