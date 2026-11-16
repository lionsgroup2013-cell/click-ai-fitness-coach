import SwiftUI

extension Image {
    static func cf(_ name: String) -> Image {
        #if XCODE_BUILD
        Image(name)
        #else
        Image(name, bundle: .module)
        #endif
    }
}

enum CFColor {
    static let background = Color(hex: 0x0B0F14)
    static let card = Color(hex: 0x171E27)
    static let surface = Color(hex: 0x222B36)
    static let accent = Color(hex: 0xA8FF60)
    static let text = Color.white
    static let secondary = Color(hex: 0xA0AAB8)
    static let divider = Color(hex: 0x303945)
    static let warning = Color(hex: 0xFFB45E)
    static let blue = Color(hex: 0x6CB8FF)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

extension View {
    func cfCard(padding: CGFloat = 18) -> some View {
        self
            .padding(padding)
            .background(CFColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    func cfScreen() -> some View {
        self
            .foregroundStyle(CFColor.text)
            .background(CFColor.background.ignoresSafeArea())
            .toolbarBackground(CFColor.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct CFCard<Content: View>: View {
    let padding: CGFloat
    @ViewBuilder var content: Content

    init(padding: CGFloat = 18, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content.cfCard(padding: padding)
    }
}

struct SectionHeader: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 20, weight: .semibold, design: .rounded))

            Spacer()

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(CFColor.accent)
            }
        }
    }
}

struct CFPill: View {
    let text: String
    var icon: String?
    var tint: Color = CFColor.accent

    var body: some View {
        HStack(spacing: 5) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
            }
            Text(text)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(tint)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(tint.opacity(0.12))
        .clipShape(Capsule())
    }
}

struct IconTile: View {
    let systemName: String
    var tint: Color = CFColor.accent
    var size: CGFloat = 44

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.4, weight: .semibold))
            .foregroundStyle(tint)
            .frame(width: size, height: size)
            .background(tint.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: size * 0.32, style: .continuous))
    }
}

struct MacroBar: View {
    let title: String
    let value: Double
    let target: Double
    let color: Color

    var progress: Double {
        guard target > 0 else { return 0 }
        return min(value / target, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(CFColor.secondary)
                Spacer()
                Text("\(Int(value)) / \(Int(target)) г")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(CFColor.text)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(CFColor.surface)
                    Capsule()
                        .fill(color)
                        .frame(width: proxy.size.width * progress)
                }
            }
            .frame(height: 6)
        }
    }
}

struct CircleProgress: View {
    let progress: Double
    let value: String
    let caption: String
    var lineWidth: CGFloat = 10

    var body: some View {
        ZStack {
            Circle()
                .stroke(CFColor.surface, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(
                    CFColor.accent,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 1) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .monospacedDigit()
                Text(caption)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(CFColor.secondary)
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundStyle(CFColor.background)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(CFColor.accent.opacity(configuration.isPressed ? 0.76 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .foregroundStyle(CFColor.text)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(configuration.isPressed ? CFColor.surface : CFColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

