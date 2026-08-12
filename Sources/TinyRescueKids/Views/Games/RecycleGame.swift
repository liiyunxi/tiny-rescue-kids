import SwiftUI

/// 关卡5 回收小能手：灰灰要回收旧物，点出可以回收的那一个
struct RecycleGame: View {
    let onSuccess: () -> Void

    private let rocky = Buddy.crew[3] // 灰灰
    @State private var question: RecycleQuestion = RecycleQuestion.bank[0]
    @State private var solved = false
    @State private var shakeTrigger = 0
    @State private var wrongEmoji: String?

    var body: some View {
        ZStack {
            PlaygroundBackground()

            VStack(spacing: 30) {
                Spacer()

                HStack(spacing: 16) {
                    Text(rocky.emoji)
                        .font(.system(size: 72))
                        .frame(width: 110, height: 110)
                        .background(rocky.uniform.opacity(0.9))
                        .cornerRadius(26)
                        .shadow(radius: 5, y: 3)
                    Text("♻️")
                        .font(.system(size: 64))
                }

                Text("点出可以回收的东西！")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(20)

                HStack(spacing: 20) {
                    ForEach(question.options, id: \.self) { emoji in
                        Button {
                            tap(emoji: emoji)
                        } label: {
                            Text(emoji)
                                .font(.system(size: 64))
                                .frame(width: 96, height: 96)
                                .background(Color.white.opacity(0.92))
                                .cornerRadius(24)
                                .shadow(radius: 4, y: 3)
                        }
                        .buttonStyle(BounceButtonStyle())
                        .gentleShake(trigger: wrongEmoji == emoji ? shakeTrigger : 0)
                        .disabled(solved)
                    }
                }

                Spacer()
                Spacer()
            }
        }
        .onAppear {
            question = RecycleQuestion.bank.randomElement()!
            Speaker.shared.speak("别丢掉，再利用！点出可以回收的东西！",
                                 pitch: rocky.pitch, rate: rocky.rate)
        }
    }

    private func tap(emoji: String) {
        if emoji == question.answer {
            solved = true
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            Speaker.shared.speak("对啦！这个可以回收！你真棒！")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onSuccess()
            }
        } else {
            wrongEmoji = emoji
            shakeTrigger += 1
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            Speaker.shared.speak("这个不能回收哦，再想一想")
        }
    }
}

// MARK: - 题库

private struct RecycleQuestion {
    let answer: String      // 可回收物
    let options: [String]   // 3个选项（含答案）

    static let bank: [RecycleQuestion] = [
        RecycleQuestion(answer: "📦", options: ["📦", "🍌", "🍎"].shuffled()),      // 纸箱 vs 果皮
        RecycleQuestion(answer: "📰", options: ["📰", "🥬", "🍞"].shuffled()),      // 报纸
        RecycleQuestion(answer: "🥫", options: ["🥫", "🍗", "🥚"].shuffled()),      // 罐头盒
        RecycleQuestion(answer: "🍾", options: ["🍾", "🧁", "🍖"].shuffled()),      // 玻璃瓶
        RecycleQuestion(answer: "🔋", options: ["🔋", "🍎", "🥕"].shuffled()),      // 电池（专门回收）
    ]
}
