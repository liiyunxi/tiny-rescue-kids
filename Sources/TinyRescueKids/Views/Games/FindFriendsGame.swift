import SwiftUI

/// 关卡1 找一找：小伙伴躲在3个掩体后面，点中找到它
struct FindFriendsGame: View {
    let onSuccess: () -> Void

    private let hidingSpots = ["⛺️", "🌳", "🛖"]
    @State private var hiddenIndex = 0
    @State private var buddy = Buddy.crew.randomElement()!
    @State private var found = false
    @State private var shakeTrigger = 0

    var body: some View {
        ZStack {
            PlaygroundBackground()

            VStack(spacing: 30) {
                Spacer()
                Text("\(buddy.name)躲起来了，找找看！")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(20)

                HStack(spacing: 24) {
                    ForEach(hidingSpots.indices, id: \.self) { i in
                        Button {
                            tap(spot: i)
                        } label: {
                            ZStack {
                                Text(hidingSpots[i])
                                    .font(.system(size: 90))
                                if found && i == hiddenIndex {
                                    Text(buddy.emoji)
                                        .font(.system(size: 64))
                                        .offset(y: -50)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .frame(width: 110, height: 130)
                        }
                        .buttonStyle(BounceButtonStyle())
                        .gentleShake(trigger: i == tappedWrongIndex ? shakeTrigger : 0)
                        .disabled(found)
                    }
                }
                Spacer()
                Spacer()
            }
        }
        .onAppear { reset() }
    }

    @State private var tappedWrongIndex = -1

    private func reset() {
        hiddenIndex = Int.random(in: 0..<hidingSpots.count)
        buddy = Buddy.crew.randomElement()!
        found = false
        tappedWrongIndex = -1
        Speaker.shared.speak(buddy.name + "躲起来了，找找看！")
    }

    private func tap(spot: Int) {
        if spot == hiddenIndex {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                found = true
            }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            Speaker.shared.speak("找到" + buddy.name + "啦！")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                onSuccess()
            }
        } else {
            // 点错了：轻轻摇一摇掩体，温柔提示，不惩罚
            tappedWrongIndex = spot
            shakeTrigger += 1
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
