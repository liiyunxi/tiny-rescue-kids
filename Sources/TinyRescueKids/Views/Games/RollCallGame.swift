import SwiftUI

/// 关卡8 汪汪队集合：莱德队长点名，点出他叫到的狗狗
struct RollCallGame: View {
    let onSuccess: () -> Void

    @State private var target: Buddy = Buddy.crew[0]
    @State private var options: [Buddy] = []
    @State private var solved = false
    @State private var shakeTrigger = 0
    @State private var wrongName: String?

    var body: some View {
        ZStack {
            PlaygroundBackground()

            VStack(spacing: 30) {
                Spacer()

                // 莱德队长 + 重听
                HStack(spacing: 16) {
                    Text("🧒")
                        .font(.system(size: 72))
                        .frame(width: 110, height: 110)
                        .background(Color(red: 0.95, green: 0.3, blue: 0.25))
                        .cornerRadius(26)
                        .shadow(radius: 5, y: 3)
                    Button {
                        speakCall()
                    } label: {
                        Text("📣")
                            .font(.system(size: 44))
                            .frame(width: 96, height: 96)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(24)
                            .shadow(radius: 4, y: 3)
                    }
                    .buttonStyle(BounceButtonStyle())
                }

                Text("莱德队长在点名，点到谁啦？")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(20)

                // 4只狗狗
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                    ForEach(options) { buddy in
                        Button {
                            tap(buddy: buddy)
                        } label: {
                            VStack(spacing: 2) {
                                Text(buddy.emoji)
                                    .font(.system(size: 56))
                                Text(buddy.name)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 120, height: 120)
                            .background(buddy.uniform.opacity(0.9))
                            .cornerRadius(26)
                            .shadow(radius: 4, y: 3)
                        }
                        .buttonStyle(BounceButtonStyle())
                        .gentleShake(trigger: wrongName == buddy.name ? shakeTrigger : 0)
                        .disabled(solved)
                    }
                }
                .padding(.horizontal, 40)

                Spacer()
                Spacer()
            }
        }
        .onAppear {
            target = Buddy.crew.randomElement()!
            options = ([target] + Buddy.crew.filter { $0 != target }.shuffled().prefix(3)).shuffled()
            speakCall()
        }
    }

    private func speakCall() {
        // 莱德的声音：清亮的少年音
        Speaker.shared.speak("汪汪队集合！这次需要——\(target.name)！",
                             pitch: 1.25, rate: 0.42)
    }

    private func tap(buddy: Buddy) {
        if buddy.name == target.name {
            solved = true
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            // 答对后狗狗用自己的声音喊口头禅
            buddy.sayCatchphrase()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                onSuccess()
            }
        } else {
            wrongName = buddy.name
            shakeTrigger += 1
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            Speaker.shared.speak("不是它哦，再听听看！")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                speakCall()
            }
        }
    }
}
