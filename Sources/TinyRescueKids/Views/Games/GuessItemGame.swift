import SwiftUI

/// 关卡5 猜猜是什么：听一段描述（语音播报），从3个物品里选出答案
struct GuessItemGame: View {
    let onSuccess: () -> Void

    @State private var riddle: Riddle = Riddle.bank[0]
    @State private var solved = false
    @State private var shakeTrigger = 0
    @State private var wrongEmoji: String?
    @State private var showOptions = false

    var body: some View {
        ZStack {
            PlaygroundBackground()

            VStack(spacing: 36) {
                Spacer()

                // 出题人：随机狗狗队员 + 重听按钮
                HStack(spacing: 20) {
                    Text(riddle.host.emoji)
                        .font(.system(size: 80))
                        .frame(width: 120, height: 120)
                        .background(riddle.host.uniform.opacity(0.9))
                        .cornerRadius(28)
                        .shadow(radius: 6, y: 4)

                    Button {
                        Speaker.shared.speak(riddle.clue)
                    } label: {
                        VStack(spacing: 4) {
                            Text("🔊")
                                .font(.system(size: 44))
                            Text(riddle.host.name + "出题")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .frame(width: 110, height: 110)
                        .background(Color(red: 0.4, green: 0.5, blue: 0.95))
                        .cornerRadius(28)
                        .shadow(radius: 6, y: 4)
                    }
                    .buttonStyle(BounceButtonStyle())
                }

                Text("听一听，点出正确答案")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(20)

                // 三个选项
                HStack(spacing: 20) {
                    ForEach(riddle.options, id: \.self) { emoji in
                        Button {
                            tap(emoji: emoji)
                        } label: {
                            Text(emoji)
                                .font(.system(size: 64))
                                .frame(width: 96, height: 96)
                                .background(Color.white.opacity(0.92))
                                .cornerRadius(24)
                                .shadow(radius: 4, y: 3)
                                .scaleEffect(showOptions ? 1 : 0.1)
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
            riddle = Riddle.bank.randomElement()!
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55).delay(0.3)) {
                showOptions = true
            }
            // 先打招呼再出题
            Speaker.shared.speak(riddle.host.name + "说：" + riddle.clue)
        }
        .onDisappear {
            Speaker.shared.stop()
        }
    }

    private func tap(emoji: String) {
        if emoji == riddle.answer {
            solved = true
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            Speaker.shared.speak("答对啦！你真棒！")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                onSuccess()
            }
        } else {
            wrongEmoji = emoji
            shakeTrigger += 1
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            Speaker.shared.speak("再想一想哦")
        }
    }
}

// MARK: - 谜题库

struct Riddle {
    /// 描述（语音播报）
    let clue: String
    /// 正确答案
    let answer: String
    /// 三个选项（含答案）
    let options: [String]
    /// 出题的狗狗队员
    let host: Buddy

    static let bank: [Riddle] = {
        func make(_ clue: String, _ answer: String, _ wrong1: String, _ wrong2: String) -> Riddle {
            Riddle(clue: clue, answer: answer,
                   options: [answer, wrong1, wrong2].shuffled(),
                   host: Buddy.crew.randomElement()!)
        }
        return [
            make("红红的，圆圆的，咬一口甜甜的，是什么水果呀？", "🍎", "🍌", "🍇"),
            make("它会喵喵叫，最喜欢捉老鼠，是什么动物呀？", "🐱", "🐶", "🐰"),
            make("着火啦！它会马上开过来灭火，是什么车呀？", "🚒", "🚓", "🚑"),
            make("下雨的时候，把它举在头上，就不会淋湿啦，是什么呀？", "☂️", "🧢", "🎩"),
            make("白白的，香香的，早上喝一杯长高高，是什么呀？", "🥛", "🧃", "🍵"),
            make("晚上它会挂在天上，弯弯的像小船，是什么呀？", "🌙", "☀️", "⭐"),
            make("它住在水里，会游泳，尾巴摆一摆，是什么呀？", "🐟", "🐦", "🐢"),
            make("长长的，黄黄的，剥开皮才能吃，是什么水果呀？", "🍌", "🍎", "🍉"),
            make("每天早上和晚上都要用它来刷牙，是什么呀？", "🪥", "🥄", "🧴"),
            make("它会嗡嗡叫，飞来飞去采花蜜，是什么小虫呀？", "🐝", "🦋", "🐞"),
        ]
    }()
}
