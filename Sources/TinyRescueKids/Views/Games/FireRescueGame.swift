import SwiftUI

/// 关卡4 灭火小英雄：和毛毛一起，点掉所有火焰
struct FireRescueGame: View {
    let onSuccess: () -> Void

    private let marshall = Buddy.crew[1] // 毛毛
    /// 6个位置，随机3个着火
    @State private var spots: [Bool] = [] // true = 着火
    @State private var remaining = 0

    var body: some View {
        ZStack {
            PlaygroundBackground()

            VStack(spacing: 30) {
                Spacer()

                // 毛毛领队
                HStack(spacing: 16) {
                    Text(marshall.emoji)
                        .font(.system(size: 72))
                        .frame(width: 110, height: 110)
                        .background(marshall.uniform.opacity(0.9))
                        .cornerRadius(26)
                        .shadow(radius: 5, y: 3)
                    Text(marshall.vehicle)
                        .font(.system(size: 72))
                }

                Text("快把火都扑灭！")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(20)

                // 2行3列火点
                VStack(spacing: 18) {
                    ForEach(0..<2, id: \.self) { row in
                        HStack(spacing: 18) {
                            ForEach(0..<3, id: \.self) { col in
                                let idx = row * 3 + col
                                FireSpot(isBurning: binding(for: idx)) {
                                    tapSpot(idx)
                                }
                            }
                        }
                    }
                }

                Spacer()
                Spacer()
            }
        }
        .onAppear {
            // 随机3个位置着火
            var s = [Bool](repeating: false, count: 6)
            for i in (0..<6).shuffled().prefix(3) { s[i] = true }
            spots = s
            remaining = 3
            Speaker.shared.speak("我，火力全开！着火啦，快把火扑灭！",
                                 pitch: marshall.pitch, rate: marshall.rate)
        }
    }

    private func binding(for idx: Int) -> Binding<Bool> {
        Binding(get: { spots.indices.contains(idx) ? spots[idx] : false },
                set: { if spots.indices.contains(idx) { spots[idx] = $0 } })
    }

    private func tapSpot(_ idx: Int) {
        guard spots[idx] else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.55)) {
            spots[idx] = false
        }
        remaining -= 1
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        if remaining == 0 {
            Speaker.shared.speak("火扑灭啦！毛毛你真棒！")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                onSuccess()
            }
        }
    }
}

private struct FireSpot: View {
    @Binding var isBurning: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Text("🌳")
                    .font(.system(size: 60))
                Text("🔥")
                    .font(.system(size: 64))
                    .offset(y: -12)
                    .opacity(isBurning ? 1 : 0)
                    .scaleEffect(isBurning ? 1 : 0.1)
                if !isBurning {
                    Text("💧")
                        .font(.system(size: 44))
                        .offset(y: -16)
                        .transition(.scale)
                }
            }
            .frame(width: 100, height: 110)
            .background(Color.white.opacity(0.75))
            .cornerRadius(22)
            .shadow(radius: 4, y: 3)
        }
        .buttonStyle(BounceButtonStyle())
        .disabled(!isBurning)
    }
}
