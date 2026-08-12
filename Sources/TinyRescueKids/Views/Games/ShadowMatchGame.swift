import SwiftUI

/// 关卡4 谁的影子：中间一个黑色剪影，从3个小伙伴里选出它
struct ShadowMatchGame: View {
    let onSuccess: () -> Void

    @State private var answer: Buddy = Buddy.crew[0]
    @State private var options: [Buddy] = []
    @State private var matched = false
    @State private var shakeTrigger = 0
    @State private var wrongId: UUID?

    var body: some View {
        ZStack {
            PlaygroundBackground()

            VStack(spacing: 36) {
                Spacer()

                Text("这是谁的影子？")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(20)

                // 影子：colorMultiply(.black) 让 emoji 变成纯黑剪影（透明区域保留）
                Text(answer.emoji)
                    .font(.system(size: 120))
                    .colorMultiply(matched ? .white : .black)
                    .animation(.easeInOut(duration: 0.4), value: matched)
                .frame(width: 160, height: 160)
                .background(Color.white.opacity(0.85))
                .cornerRadius(30)
                .shadow(radius: 6, y: 4)

                HStack(spacing: 24) {
                    ForEach(options) { buddy in
                        Button {
                            tap(buddy: buddy)
                        } label: {
                            Text(buddy.emoji)
                                .font(.system(size: 68))
                                .frame(width: 100, height: 100)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(24)
                                .shadow(radius: 4, y: 3)
                        }
                        .buttonStyle(BounceButtonStyle())
                        .gentleShake(trigger: wrongId == buddy.id ? shakeTrigger : 0)
                        .disabled(matched)
                    }
                }

                Spacer()
                Spacer()
            }
        }
        .onAppear { setup() }
    }

    private func setup() {
        answer = Buddy.crew.randomElement()!
        var opts = [answer]
        let others = Buddy.crew.filter { $0 != answer }.shuffled()
        opts.append(contentsOf: others.prefix(2))
        options = opts.shuffled()
        matched = false
        wrongId = nil
    }

    private func tap(buddy: Buddy) {
        if buddy == answer {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.5)) {
                matched = true // 影子变成真身
            }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                onSuccess()
            }
        } else {
            wrongId = buddy.id
            shakeTrigger += 1
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
