import SwiftUI

/// 主界面：救援队基地 + 关卡地图
struct HomeView: View {
    @EnvironmentObject var progress: ProgressStore
    @State private var selectedLevel: Level?

    var body: some View {
        NavigationStack {
            ZStack {
                PlaygroundBackground()

                VStack(spacing: 20) {
                    // 标题区
                    VStack(spacing: 4) {
                        Text("🐶 狗狗救援队 🚨")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(red: 0.95, green: 0.45, blue: 0.25))
                        HStack(spacing: 4) {
                            ForEach(0..<max(progress.totalStars, 0), id: \.self) { _ in
                                Text("⭐").font(.title2)
                            }
                            if progress.totalStars == 0 {
                                Text("出发去完成任务吧！")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.top, 30)

                    // 队员展示条：6只狗狗，点一下会说名字
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(Buddy.crew) { buddy in
                                Button {
                                    Speaker.shared.speak("我是" + buddy.name + "！")
                                } label: {
                                    VStack(spacing: 2) {
                                        Text(buddy.emoji)
                                            .font(.system(size: 38))
                                        Text(buddy.name)
                                            .font(.system(size: 13, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 70, height: 82)
                                    .background(buddy.uniform.opacity(0.9))
                                    .cornerRadius(18)
                                }
                                .buttonStyle(BounceButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                    }

                    // 关卡列表
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(Level.all) { level in
                                levelCard(level)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 30)
                    }
                }
            }
            .fullScreenCover(item: $selectedLevel) { level in
                GameHostView(level: level)
                    .environmentObject(progress)
            }
            .onAppear {
                Speaker.shared.speak("狗狗救援队，出发做任务啦！")
            }
        }
    }

    @ViewBuilder
    private func levelCard(_ level: Level) -> some View {
        let unlocked = progress.isUnlocked(level)
        let completed = progress.isCompleted(level)

        Button {
            if unlocked { selectedLevel = level }
        } label: {
            HStack(spacing: 16) {
                Text(level.kind.emoji)
                    .font(.system(size: 48))
                    .frame(width: 80, height: 80)
                    .background(unlocked ? Color.white : Color.gray.opacity(0.3))
                    .cornerRadius(20)

                VStack(alignment: .leading, spacing: 4) {
                    Text("第 \(level.id + 1) 关")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                    Text(level.kind.title)
                        .font(.system(size: 26, weight: .heavy, design: .rounded))
                        .foregroundColor(unlocked ? .primary : .gray)
                }
                Spacer()
                Text(completed ? "⭐" : (unlocked ? "▶️" : "🔒"))
                    .font(.system(size: 32))
            }
            .padding(14)
            .background(unlocked ? Color.white.opacity(0.9) : Color.gray.opacity(0.15))
            .cornerRadius(24)
            .shadow(color: .black.opacity(unlocked ? 0.12 : 0), radius: 6, y: 4)
        }
        .buttonStyle(BounceButtonStyle())
        .disabled(!unlocked)
    }
}
