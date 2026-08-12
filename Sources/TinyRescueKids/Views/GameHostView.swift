import SwiftUI

/// 关卡容器：负责回合计数、通关判定、庆祝页
struct GameHostView: View {
    let level: Level
    @EnvironmentObject var progress: ProgressStore
    @Environment(\.dismiss) private var dismiss

    @State private var round = 0
    @State private var showCelebration = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 顶栏：返回 + 进度爪印
                HStack {
                    Button { dismiss() } label: {
                        Text("🏠")
                            .font(.system(size: 34))
                            .frame(width: 64, height: 64)
                            .background(Color.white.opacity(0.85))
                            .cornerRadius(18)
                    }
                    Spacer()
                    HStack(spacing: 6) {
                        ForEach(0..<level.kind.roundsToWin, id: \.self) { i in
                            Text(i < round ? "🐾" : "⚪️")
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(18)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                // 游戏本体
                gameView
                    .id(round) // 每回合重建，重置游戏状态
            }

            if showCelebration {
                CelebrationView {
                    progress.complete(level: level)
                    dismiss()
                }
            }
        }
        .onAppear {
            // 进关语音播报玩法说明（自己播报的关卡除外，避免抢话）
            let selfSpeaking: Set<GameKind> = [.guessItem, .sizeSort, .fireRescue, .recycle, .rollCall]
            if !selfSpeaking.contains(level.kind) {
                Speaker.shared.speak(level.kind.instruction)
            }
        }
        .onDisappear {
            Speaker.shared.stop()
        }
    }

    @ViewBuilder
    private var gameView: some View {
        switch level.kind {
        case .findFriends:
            FindFriendsGame(onSuccess: advance)
        case .colorRescue:
            ColorRescueGame(onSuccess: advance)
        case .countStars:
            CountStarsGame(onSuccess: advance)
        case .shadowMatch:
            ShadowMatchGame(onSuccess: advance)
        case .guessItem:
            GuessItemGame(onSuccess: advance)
        case .sizeSort:
            SizeSortGame(onSuccess: advance)
        case .fireRescue:
            FireRescueGame(onSuccess: advance)
        case .recycle:
            RecycleGame(onSuccess: advance)
        case .rollCall:
            RollCallGame(onSuccess: advance)
        }
    }

    private func advance() {
        if round + 1 >= level.kind.roundsToWin {
            showCelebration = true
        } else {
            round += 1
        }
    }
}
