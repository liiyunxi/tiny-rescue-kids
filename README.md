# 🐶 狗狗救援队（TinyRescueKids）

面向 3-4 岁儿童的关卡式 iOS 游戏，Swift + SwiftUI 实现。
美术素材全部使用 Emoji + SwiftUI 原生绘制，**零资源文件依赖**，开箱即跑。
全程中文语音引导（AVSpeechSynthesizer，离线可用），不识字的幼儿也能独立玩。

> ⚠️ 版权说明：本项目应用户要求使用了《汪汪队立大功》(PAW Patrol) 的角色名称
> （阿奇、毛毛、天天、灰灰、小砾、路马）。这些名称/形象受版权保护，
> **仅限个人学习与家庭自用；如需上架 App Store 或商用，请把 `GameModels.swift`
> 中 `Buddy.crew` 替换为原创角色名**（Emoji 形象与玩法本身不受限）。

## 🎮 关卡设计

| 关卡 | 玩法 | 锻炼能力 | 解锁条件 |
|------|------|----------|----------|
| 1 寻找狗狗队员 🔍 | 队员藏在3个掩体后，点中找到它 | 观察力、客体永久性 | 默认开放 |
| 2 水果快递 🚗 | 听狗狗的需求，点击同色水果送到它的载具上 | 颜色认知、听力理解 | 1 颗⭐ |
| 3 点亮星星 ⭐ | 逐一点亮 1-3 颗星星并计数 | 数感（1-3） | 2 颗⭐ |
| 4 灭火小英雄 🚒 | 和毛毛一起点灭所有火焰 | 反应力、手眼协调 | 3 颗⭐ |
| 5 回收小能手 ♻️ | 帮灰灰挑出可以回收的东西 | 分类判断、环保启蒙 | 4 颗⭐ |
| 6 谁的影子 🌙 | 根据黑色剪影选出对应狗狗队员 | 形状匹配 | 5 颗⭐ |
| 7 猜猜是什么 🎁 | 听狗狗的描述（语音），从3个物品里猜出答案 | 语言理解、联想力 | 6 颗⭐ |
| 8 汪汪队集合 📣 | 听莱德队长点名，点出他叫到的狗狗 | 听力辨人、角色认知 | 7 颗⭐ |
| 9 大大小小 🎈 | 按语音提示点出最大/最小的物品 | 大小概念、比较 | 8 颗⭐ |

每关 3 回合，全部完成即通关 +1⭐，星星用于解锁后续关卡。

## 🐕 角色还原（官方设定）

每只狗狗都有官方口头禅和**专属 TTS 声调**（主页点一下就会喊）：

| 队员 | 品种 | 载具 | 口头禅 | 声音特点 |
|------|------|------|--------|----------|
| 阿奇 | 德国牧羊犬 | 🚓 警车 | 包在我身上！ | 沉稳有力 |
| 毛毛 | 大麦町犬 | 🚒 消防车 | 我，火力全开！ | 活泼热情 |
| 天天 | 可卡颇犬 | 🚁 直升机 | 让我们飞上天空吧！ | 高音女声 |
| 灰灰 | 混血犬 | 🚛 回收车 | 别丢掉，再利用！ | 平稳 |
| 小砾 | 英国斗牛犬 | 🚜 工程车 | 小砾往前冲！ | 低沉憨憨慢速 |
| 路马 | 拉布拉多犬 | ⛵ 气垫船 | 开始行动吧！ | 轻快幽默 |

开场白为莱德队长经典台词："没有困难的工作，只有勇敢的狗狗！汪汪队要出动了！"

## 🧒 低龄化设计原则

- **无失败惩罚**：点错只轻轻摇一摇 + 语音提示"再想一想哦"，绝不出现"失败"
- **全程语音引导**：玩法说明、出题、答对鼓励全部语音播报，不依赖识字
- **超大点击区域**：所有可点元素 ≥ 88pt，圆角卡片式按钮
- **即时正反馈**：每次正确操作都有弹跳动画 + 触觉震动；通关放烟花彩带
- **竖屏锁定 + 全屏**：避免误触旋转打断游戏
- **进度自动保存**：UserDefaults 存储星星与通关记录

## 🚀 如何运行（需要 macOS + Xcode 15+）

方式一：XcodeGen（推荐，项目已带配置）

```bash
brew install xcodegen
cd tiny-rescue-kids
xcodegen generate
open TinyRescueKids.xcodeproj
```

方式二：手动建工程

1. Xcode → New Project → iOS → App，Interface 选 SwiftUI，语言 Swift
2. 把 `Sources/TinyRescueKids/` 下所有 `.swift` 文件拖进工程
3. 删除 Xcode 自动生成的 `ContentView.swift` 和原 App 入口文件
4. 选择 iPhone/iPad 模拟器，⌘R 运行

## 📁 目录结构

```
tiny-rescue-kids/
├── project.yml                  # XcodeGen 工程配置
└── Sources/TinyRescueKids/
    ├── TinyRescueKidsApp.swift  # App 入口
    ├── Models/
    │   └── GameModels.swift     # 关卡定义、进度存储、汪汪队角色
    ├── Views/
    │   ├── HomeView.swift       # 主界面（关卡地图 + 队员展示条）
    │   ├── GameHostView.swift   # 关卡容器（回合计数/庆祝/语音播报）
    │   └── Games/               # 6 个关卡游戏
    └── Components/
        ├── BigButton.swift      # 大按钮、背景
        ├── Speaker.swift        # 中文语音播报（AVSpeechSynthesizer）
        └── CelebrationView.swift# 通关庆祝、温柔抖动反馈
```

## 📦 打包 .ipa

**前提：iOS 应用只能在 macOS + Xcode 上编译打包，Windows 无法产出 .ipa。**

### 方案A：你有 Mac（推荐）

```bash
# 首次：打开工程设置签名（免费 Apple ID 即可）
xcodegen generate && open TinyRescueKids.xcodeproj
# Xcode → 项目 → Signing & Capabilities → Team 选你的 Apple ID

# 之后一键打包：
chmod +x build-ipa.sh && ./build-ipa.sh
# 产物在 build/ipa/TinyRescueKids.ipa
```

- 免费账号（development 方式）：只能装到你自己 iPhone/iPad 上，证书7天过期需重装
- 付费开发者账号（$99/年）：可改 `ExportOptions.plist` 的 `method` 为 `ad-hoc` 或 `app-store`

### 方案B：没有 Mac —— GitHub Actions 云端打包

1. 把项目推到 GitHub 仓库（`.github/workflows/build-ipa.yml` 已配好）
2. 仓库页面 → Actions → Build IPA → Run workflow
3. 跑完后在 Artifacts 下载未签名 ipa
4. 用 [Sideloadly](https://sideloadly.io/) 或 AltStore + 免费 Apple ID 自签名装到手机

## 🔜 可扩展方向

- 用 AVAudioPlayer 加音效（正确/点击/通关欢呼）
- 更多谜题扩充 `Riddle.bank`（当前10条，随时加）
- 更多关卡：简单拼图（2片）、听音辨动物、形状分类
- 家长模式：屏幕使用时长限制、关卡进度重置
