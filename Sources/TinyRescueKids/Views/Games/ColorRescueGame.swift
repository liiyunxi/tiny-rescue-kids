import SwiftUI

/// 关卡2 水果快递：点击和目标小车同色的水果（3选1，点击制，比拖拽更适合幼儿）
struct ColorRescueGame: View {
    let onSuccess: () -> Void

    struct Fruit: Identifiable, Equatable {
        let id = UUID()
        let emoji: String
        let colorName: String
        let color: Color
    }

    private let fruits: [Fruit] = [
        Fruit(emoji: "🍎", colorName: "红色", color: .red),
        Fruit(emoji: "🍌", colorName: "黄色", color: .yellow),
        Fruit(emoji: "🍇", colorName: "紫色", color: .purple),
    ]

    @State private var target: Fruit?
    @State private var shakeTrigger = 0
    @State private var wrongId: UUID?
    @State private var delivered = false
    @State private var driver: Buddy = Buddy.crew[0]

    var body: some View {
        ZStack {
            PlaygroundBackground()

            VStack(spacing: 36) {
                Spacer()

                if let target {
                    // 狗狗队员的载具
                    VStack(spacing: 8) {
                        Text("把水果送到" + driver.name + "的车上")
                            .font(.system(size: 24, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.6))
                        ZStack {
                            Text(driver.vehicle).font(.system(size: 100))
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(target.color, lineWidth: 8)
                                .frame(width: 150, height: 110)
                            Text(driver.emoji)
                                .font(.system(size: 36))
                                .offset(x: -50, y: -35)
                            if delivered {
                                Text(target.emoji)
                                    .font(.system(size: 50))
                                    .offset(y: -40)
                                    .transition(.scale)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(24)
                }

                // 三个水果
                HStack(spacing: 28) {
                    ForEach(fruits.shuffled(), id: \.id) { fruit in
                        Button {
                            tap(fruit: fruit)
                        } label: {
                            Text(fruit.emoji)
                                .font(.system(size: 72))
                                .frame(width: 104, height: 104)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(24)
                                .shadow(radius: 4, y: 3)
                        }
                        .buttonStyle(BounceButtonStyle())
                        .gentleShake(trigger: wrongId == fruit.id ? shakeTrigger : 0)
                        .disabled(delivered)
                    }
                }
                .id(target?.id) // 每轮重排

                Spacer()
                Spacer()
            }
        }
        .onAppear {
            if target == nil {
                target = fruits.randomElement()
                driver = Buddy.crew.randomElement()!
                if let t = target {
                    Speaker.shared.speak(driver.name + "想要" + t.colorName + "的水果")
                }
            }
        }
    }

    private func tap(fruit: Fruit) {
        if fruit.id == target?.id {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                delivered = true
            }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                onSuccess()
            }
        } else {
            wrongId = fruit.id
            shakeTrigger += 1
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
