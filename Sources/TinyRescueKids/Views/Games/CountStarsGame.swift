import SwiftUI

/// 关卡3 点亮星星：天上出现1-3颗暗星，逐个点亮，练数数
struct CountStarsGame: View {
    let onSuccess: () -> Void

    @State private var starCount = 1
    @State private var lit: Set<Int> = []

    var body: some View {
        ZStack {
            // 夜空背景（本关特殊）
            LinearGradient(
                colors: [Color(red: 0.15, green: 0.2, blue: 0.45),
                         Color(red: 0.35, green: 0.3, blue: 0.6)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()
                Text("点一点，把星星都点亮")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)

                // 已点亮计数：用大数字+爪印强化数字概念
                Text(lit.isEmpty ? " " : "\(lit.count)")
                    .font(.system(size: 60, weight: .heavy, design: .rounded))
                    .foregroundColor(.yellow)
                    .frame(height: 70)

                HStack(spacing: 32) {
                    ForEach(0..<starCount, id: \.self) { i in
                        Button {
                            lightUp(i)
                        } label: {
                            Text(lit.contains(i) ? "🌟" : "⭐️")
                                .font(.system(size: 80))
                                .opacity(lit.contains(i) ? 1 : 0.35)
                                .scaleEffect(lit.contains(i) ? 1.15 : 1.0)
                        }
                        .buttonStyle(BounceButtonStyle())
                        .disabled(lit.contains(i))
                    }
                }

                Spacer()
                Spacer()
            }
        }
        .onAppear {
            starCount = Int.random(in: 1...3)
            lit = []
        }
    }

    private func lightUp(_ i: Int) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
            lit.insert(i)
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        if lit.count == starCount {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                onSuccess()
            }
        }
    }
}
