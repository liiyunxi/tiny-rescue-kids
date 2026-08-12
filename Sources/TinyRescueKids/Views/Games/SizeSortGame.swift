import SwiftUI

/// 关卡6 大大小小：同一个物品三种大小，按要求点出最大或最小的那个
struct SizeSortGame: View {
    let onSuccess: () -> Void

    @State private var item = "🎈"
    @State private var askBiggest = true
    @State private var solved = false
    @State private var shakeTrigger = 0
    @State private var wrongIndex: Int?
    @State private var appeared = false
    @State private var shuffledOrder: [Int] = [0, 1, 2]

    /// 大中小三档尺寸（索引即档位）
    private let sizes: [CGFloat] = [52, 88, 128]

    var body: some View {
        ZStack {
            PlaygroundBackground()

            VStack(spacing: 40) {
                Spacer()

                Text(askBiggest ? "点出最大的那一个！" : "点出最小的那一个！")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(20)

                // 三个不同大小的物品，随机顺序摆放
                HStack(alignment: .bottom, spacing: 30) {
                    ForEach(shuffledOrder, id: \.self) { sizeIndex in
                        Button {
                            tap(sizeIndex: sizeIndex)
                        } label: {
                            Text(item)
                                .font(.system(size: sizes[sizeIndex]))
                                .frame(width: 140, height: 150)
                                .background(Color.white.opacity(0.75))
                                .cornerRadius(24)
                                .shadow(radius: 4, y: 3)
                                .scaleEffect(appeared ? 1 : 0.1)
                        }
                        .buttonStyle(BounceButtonStyle())
                        .gentleShake(trigger: wrongIndex == sizeIndex ? shakeTrigger : 0)
                        .disabled(solved)
                    }
                }

                Spacer()
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            item = ["🎈", "⚽️", "🧸", "🍩", "🌻"].randomElement()!
            askBiggest = Bool.random()
            shuffledOrder = [0, 1, 2].shuffled()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55).delay(0.2)) {
                appeared = true
            }
            Speaker.shared.speak(askBiggest ? "点出最大的那一个！" : "点出最小的那一个！")
        }
        .onDisappear {
            Speaker.shared.stop()
        }
    }

    private func tap(sizeIndex: Int) {
        let target = askBiggest ? 2 : 0
        if sizeIndex == target {
            solved = true
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            Speaker.shared.speak("对啦！好厉害！")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                onSuccess()
            }
        } else {
            wrongIndex = sizeIndex
            shakeTrigger += 1
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            Speaker.shared.speak("再看一看哦")
        }
    }
}
