import SwiftUI
import Combine

// MARK: - 关卡定义

enum GameKind: String, CaseIterable, Codable {
    case findFriends   // 找一找：找到躲起来的狗狗队员
    case colorRescue   // 颜色配对：把水果送到同色小车上
    case countStars    // 数一数：点亮星星
    case shadowMatch   // 影子配对：谁的影子？
    case guessItem     // 听描述猜物品
    case sizeSort      // 比一比：找出最大/最小的

    var title: String {
        switch self {
        case .findFriends: return "寻找狗狗队员"
        case .colorRescue: return "水果快递"
        case .countStars:  return "点亮星星"
        case .shadowMatch: return "谁的影子"
        case .guessItem:   return "猜猜是什么"
        case .sizeSort:    return "大大小小"
        }
    }

    /// 进关时朗读的语音提示（3-4岁儿童听不懂文字，全部语音引导）
    var instruction: String {
        switch self {
        case .findFriends: return "狗狗队员躲起来啦，快把它找出来吧！"
        case .colorRescue: return "小车子想吃什么颜色的水果呢？点一点吧！"
        case .countStars:  return "把星星一颗一颗点亮吧！"
        case .shadowMatch: return "这是谁的影子呢？"
        case .guessItem:   return "仔细听一听，猜猜说的是什么？"
        case .sizeSort:    return "仔细看一看，哪一个才是对的呢？"
        }
    }

    var emoji: String {
        switch self {
        case .findFriends: return "🔍"
        case .colorRescue: return "🚗"
        case .countStars:  return "⭐"
        case .shadowMatch: return "🌙"
        case .guessItem:   return "🎁"
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

// MARK: - 汪汪队狗狗队员
//
// ⚠️ 版权说明：以下角色名称来自动画《汪汪队立大功》(PAW Patrol)，
// 仅限个人学习 / 家庭自用。如需上架 App Store 或商用，
// 请替换为原创角色名（Emoji 形象不受限）。

struct Buddy: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let emoji: String
    /// 队员的标志性载具
    let vehicle: String
    /// 制服颜色（每个队员的标志性颜色）
    let uniform: Color

    static let crew: [Buddy] = [
        Buddy(name: "阿奇", emoji: "🐶", vehicle: "🚓", uniform: Color(red: 0.2, green: 0.45, blue: 0.95)), // 警犬·蓝
        Buddy(name: "毛毛", emoji: "🐕", vehicle: "🚒", uniform: Color(red: 0.95, green: 0.25, blue: 0.2)), // 消防犬·红
        Buddy(name: "天天", emoji: "🐩", vehicle: "🚁", uniform: Color(red: 1.0,  green: 0.45, blue: 0.7)), // 飞行犬·粉
        Buddy(name: "灰灰", emoji: "🦮", vehicle: "🚛", uniform: Color(red: 0.25, green: 0.75, blue: 0.4)), // 环保犬·绿
        Buddy(name: "小砾", emoji: "🐕‍🦺", vehicle: "🚜", uniform: Color(red: 1.0,  green: 0.75, blue: 0.15)), // 工程犬·黄
        Buddy(name: "路马", emoji: "🐺", vehicle: "⛵", uniform: Color(red: 1.0,  green: 0.5,  blue: 0.1)),  // 水上犬·橙
    ]
}
