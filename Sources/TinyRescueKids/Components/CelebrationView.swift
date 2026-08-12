import SwiftUI

/// 通关庆祝：大星星弹跳 + 彩带飘落 + 触觉震动
struct CelebrationView: View {
    let onDone: () -> Void

    @State private var starScale: CGFloat = 0.1
    @State private var confetti: [ConfettiPiece] = []
    @State private var showButton = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.35).ignoresSafeArea()

            // 彩带
            ForEach(confetti) { piece in
                Text(piece.emoji)
                    .font(.system(size: piece.size))
                    .position(piece.position)
                    .rotationEffect(.degrees(piece.rotation))
            }

            VStack(spacing: 24) {
                Text("🌟")
                    .font(.system(size: 140))
                    .scaleEffect(starScale)
                    .rotationEffect(.degrees(starScale > 0.9 ? 360 : 0))

                Text("太棒了！")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 4)

                if showButton {
                    BigButton(title: "继续", emoji: "🎉", color: .orange) {
                        onDone()
                    }
                    .padding(.horizontal, 60)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            // 成功震动反馈
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

            withAnimation(.spring(response: 0.5, dampingFraction: 0.45)) {
                starScale = 1.0
            }
            spawnConfetti()
            withAnimation(.spring().delay(0.8)) {
                showButton = true
            }
        }
    }

    private func spawnConfetti() {
        let emojis = ["🎈", "🎊", "⭐", "💛", "🧡", "💜", "❤️"]
        let screen = UIScreen.main.bounds
        for i in 0..<24 {
            let piece = ConfettiPiece(
                emoji: emojis.randomElement()!,
                size: CGFloat.random(in: 20...40),
                position: CGPoint(x: CGFloat.random(in: 0...screen.width),
                                  y: -50),
                rotation: 0
            )
            confetti.append(piece)
            // 逐一下落
            withAnimation(.linear(duration: Double.random(in: 1.5...2.8)).delay(Double(i) * 0.05)) {
                if let idx = confetti.firstIndex(where: { $0.id == piece.id }) {
                    confetti[idx].position.y = screen.height + 60
                    confetti[idx].rotation = Double.random(in: -360...360)
                }
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let emoji: String
    let size: CGFloat
    var position: CGPoint
    var rotation: Double
}

/// 点错了的温柔反馈：轻轻摇一摇，不惩罚
struct GentleShake: ViewModifier {
    let trigger: Int

    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(shakes: CGFloat(trigger)))
            .animation(.default, value: trigger)
    }
}

struct ShakeEffect: GeometryEffect {
    var shakes: CGFloat
    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = 10 * sin(shakes * .pi * 3)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

extension View {
    func gentleShake(trigger: Int) -> some View {
        modifier(GentleShake(trigger: trigger))
    }
}
