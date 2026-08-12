import SwiftUI
import Combine

// MARK: - 关卡定义

enum GameKind: String, CaseIterable, Codable {
    case findFriends   // 找一找：找到躲起来的狗狗队员
    case colorRescue   // 颜色配对：把水果送到同色小车上
    case countStars    // 数一数：点亮星星
    case fireRescue    // 灭火：和毛毛一起扑灭火焰
    case recycle       // 回收：帮灰灰挑出可回收物
    case shadowMatch   // 影子配对：谁的影子？
    case guessItem     // 听描述猜物品
    case rollCall      // 莱德点名：听名字点出狗狗
    case sizeSort      // 比一比：找出最大/最小的

    var title: String {
        switch self {
        case .findFriends: return "寻找狗狗队员"
        case .colorRescue: return "水果快递"
        case .countStars:  return "点亮星星"
        case .fireRescue:  return "灭火小英雄"
        case .recycle:     return "回收小能手"
        case .shadowMatch: return "谁的影子"
        case .guessItem:   return "猜猜是什么"
        case .rollCall:    return "汪汪队集合"
        case .sizeSort:    return "大大小小"
        }
    }

    /// 进关时朗读的语音提示（3-4岁儿童听不懂文字，全部语音引导）
    var instruction: String {
        switch self {
        case .findFriends: return "狗狗队员躲起来啦，快把它找出来吧！"
        case .colorRescue: return "小车子想吃什么颜色的水果呢？点一点吧！"
        case .countStars:  return "把星星一颗一颗点亮吧！"
        case .fireRescue:  return "着火啦！快和毛毛一起把火扑灭！"
        case .recycle:     return "灰灰要回收旧物啦，点出可以回收的东西！"
        case .shadowMatch: return "这是谁的影子呢？"
        case .guessItem:   return "仔细听一听，猜猜说的是什么？"
        case .rollCall:    return "莱德队长在点名，点出他叫到的狗狗！"
        case .sizeSort:    return "仔细看一看，哪一个才是对的呢？"
        }
    }

    var emoji: String {
        switch self {
        case .findFriends: return "🔍"
        case .colorRescue: return "🚗"
        case .countStars:  return "⭐"
        case .fireRescue:  return "🚒"
        case .recycle:     return "♻️"
        case .shadowMatch: return "🌙"
        case .guessItem:   return "🎁"
        case .rollCall:    return "📣"
        case .sizeSort:    return "🎈"
        }
    }

    /// 每关需要成功几次才算通关
    var roundsToWin: Int { 3 }
}

struct Level: Identifiable {
    let id: Int
    let kind: GameKind
    /// 解锁所需星星数
    let starsRequired: Int

    static let all: [Level] = GameKind.allCases.enumerated().map { index, kind in
        Level(id: index, kind: kind, starsRequired: index == 0 ? 0 : index)
    }
}

// MARK: - 进度存储（UserDefaults）

final class ProgressStore: ObservableObject {
    @AppStorage("totalStars") private(set) var totalStars: Int = 0
    @AppStorage("completedLevelsRaw") private var completedLevelsRaw: String = ""

    private var completedLevels: Set<Int> {
        Set(completedLevelsRaw.split(separator: ",").compactMap { Int($0) })
    }

    func isCompleted(_ level: Level) -> Bool {
        completedLevels.contains(level.id)
    }

    func isUnlocked(_ level: Level) -> Bool {
        totalStars >= level.starsRequired
    }

    /// 通关一关：+1 星星。重复通关不重复加星。
    func complete(level: Level) {
        var set = completedLevels
        guard !set.contains(level.id) else { return }
        set.insert(level.id)
        completedLevelsRaw = set.map(String.init).joined(separator: ",")
        totalStars += 1
    }
}

// MARK: - 汪汪队狗狗队员（官方设定还原）
//
// ⚠️ 版权说明：以下角色名称、口头禅来自动画《汪汪队立大功》(PAW Patrol)，
// 仅限个人学习 / 家庭自用。如需上架 App Store 或商用，
// 请替换为原创角色名与台词（Emoji 形象不受限）。

struct Buddy: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let emoji: String
    /// 品种（官方设定）
    let breed: String
    /// 队员的标志性载具
    let vehicle: String
    /// 制服颜色（每个队员的标志性颜色）
    let uniform: Color
    /// 官方口头禅
    let catchphrase: String
    /// 专属声调：TTS 音调（1.0 基准，越高越尖）
    let pitch: Float
    /// 专属声调：TTS 语速（0.5 基准，越小越慢）
    let rate: Float

    /// 用狗狗的专属声音喊口头禅
    func sayCatchphrase() {
        Speaker.shared.speak("我是\(name)！\(catchphrase)", pitch: pitch, rate: rate)
    }

    static let crew: [Buddy] = [
        // 阿奇 Chase：德国牧羊犬·警犬·深蓝·02号警车，声音沉稳有力
        Buddy(name: "阿奇", emoji: "🐶", breed: "德国牧羊犬", vehicle: "🚓",
              uniform: Color(red: 0.15, green: 0.35, blue: 0.85),
              catchphrase: "包在我身上！", pitch: 0.9, rate: 0.44),
        // 毛毛 Marshall：大麦町犬·消防犬·红·03号消防车，活泼热情
        Buddy(name: "毛毛", emoji: "🐕", breed: "大麦町犬", vehicle: "🚒",
              uniform: Color(red: 0.95, green: 0.25, blue: 0.2),
              catchphrase: "我，火力全开！", pitch: 1.1, rate: 0.48),
        // 天天 Skye：可卡颇犬·飞行犬·粉·04号直升机，女声音调高
        Buddy(name: "天天", emoji: "🐩", breed: "可卡颇犬", vehicle: "🚁",
              uniform: Color(red: 1.0, green: 0.45, blue: 0.7),
              catchphrase: "让我们飞上天空吧！", pitch: 1.4, rate: 0.46),
        // 灰灰 Rocky：混血犬·环保犬·绿·05号回收车
        Buddy(name: "灰灰", emoji: "🦮", breed: "混血犬", vehicle: "🚛",
              uniform: Color(red: 0.25, green: 0.75, blue: 0.4),
              catchphrase: "别丢掉，再利用！", pitch: 1.0, rate: 0.42),
        // 小砾 Rubble：英国斗牛犬·工程犬·黄·06号工程车，憨憨的低沉慢速
        Buddy(name: "小砾", emoji: "🐕‍🦺", breed: "英国斗牛犬", vehicle: "🚜",
              uniform: Color(red: 1.0, green: 0.75, blue: 0.15),
              catchphrase: "小砾往前冲！", pitch: 0.8, rate: 0.36),
        // 路马 Zuma：拉布拉多犬·水上犬·橙·07号气垫船，幽默
        Buddy(name: "路马", emoji: "🐺", breed: "拉布拉多犬", vehicle: "⛵",
              uniform: Color(red: 1.0, green: 0.5, blue: 0.1),
              catchphrase: "开始行动吧！", pitch: 1.05, rate: 0.44),
    ]

    /// 莱德队长的开场白
    static let ryderGreeting = "没有困难的工作，只有勇敢的狗狗！汪汪队要出动了！"
}
