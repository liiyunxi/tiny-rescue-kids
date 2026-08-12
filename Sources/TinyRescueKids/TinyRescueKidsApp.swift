import SwiftUI

@main
struct TinyRescueKidsApp: App {
    @StateObject private var progress = ProgressStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(progress)
                // 3-4岁儿童：锁定竖屏，避免误旋转打断游戏
                .preferredColorScheme(.light)
        }
    }
}
