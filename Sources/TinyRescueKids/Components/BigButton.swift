import SwiftUI

/// 超大圆角按钮：3-4岁儿童手指精度差，最小点击区域 88pt
struct BigButton: View {
    let title: String
    let emoji: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(emoji).font(.system(size: 36))
                Text(title)
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 88)
            .background(color)
            .cornerRadius(28)
            .shadow(color: color.opacity(0.4), radius: 8, y: 5)
        }
        .buttonStyle(BounceButtonStyle())
    }
}

/// 按下回弹效果——每次点击都有即时物理反馈
struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

/// 背景：柔和的天空渐变 + 草地，全局统一
struct PlaygroundBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.55, green: 0.85, blue: 1.0),
                         Color(red: 0.85, green: 0.95, blue: 1.0)],
                startPoint: .top, endPoint: .bottom
            )
            VStack {
                Spacer()
                Ellipse()
                    .fill(Color(red: 0.55, green: 0.85, blue: 0.45))
                    .frame(height: 260)
                    .offset(y: 60)
            }
        }
        .ignoresSafeArea()
    }
}
