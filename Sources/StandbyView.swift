import SwiftUI
import UIKit

private struct StandbyPalette {
    let top: Color
    let bottom: Color
}

struct StandbyView: View {
    @EnvironmentObject private var wakeManager: WakeManager
    @StateObject private var weatherManager = WeatherManager()

    @AppStorage("standbyColorIndex") private var standbyColorIndex: Int = 0
    @State private var now = Date()
    @State private var displayedTime: String = ""

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private let palettes: [StandbyPalette] = [
        .init(top: Color(red: 0.97, green: 0.48, blue: 0.44), bottom: Color(red: 0.86, green: 0.47, blue: 0.78)),
        .init(top: Color(red: 1.00, green: 0.37, blue: 0.25), bottom: Color(red: 0.99, green: 0.63, blue: 0.28)),
        .init(top: Color(red: 0.98, green: 0.60, blue: 0.16), bottom: Color(red: 0.96, green: 0.82, blue: 0.24)),
        .init(top: Color(red: 0.82, green: 0.93, blue: 0.25), bottom: Color(red: 0.60, green: 0.87, blue: 0.22)),
        .init(top: Color(red: 0.34, green: 0.90, blue: 0.39), bottom: Color(red: 0.19, green: 0.78, blue: 0.42)),
        .init(top: Color(red: 0.19, green: 0.89, blue: 0.67), bottom: Color(red: 0.17, green: 0.77, blue: 0.83)),
        .init(top: Color(red: 0.20, green: 0.84, blue: 0.98), bottom: Color(red: 0.22, green: 0.62, blue: 0.99)),
        .init(top: Color(red: 0.28, green: 0.67, blue: 1.00), bottom: Color(red: 0.33, green: 0.48, blue: 0.98)),
        .init(top: Color(red: 0.52, green: 0.56, blue: 1.00), bottom: Color(red: 0.62, green: 0.44, blue: 0.98)),
        .init(top: Color(red: 0.75, green: 0.48, blue: 0.99), bottom: Color(red: 0.89, green: 0.44, blue: 0.95)),
        .init(top: Color(red: 0.96, green: 0.41, blue: 0.82), bottom: Color(red: 0.99, green: 0.36, blue: 0.63)),
        .init(top: Color(red: 0.98, green: 0.34, blue: 0.50), bottom: Color(red: 0.95, green: 0.30, blue: 0.40)),
        .init(top: Color(red: 0.92, green: 0.55, blue: 0.41), bottom: Color(red: 0.84, green: 0.67, blue: 0.45)),
        .init(top: Color(red: 0.73, green: 0.73, blue: 0.73), bottom: Color(red: 0.95, green: 0.95, blue: 0.95))
    ]

    private var palette: StandbyPalette {
        let safeIndex = ((standbyColorIndex % palettes.count) + palettes.count) % palettes.count
        return palettes[safeIndex]
    }

    var body: some View {
        GeometryReader { geo in
            let leftInset = max(geo.safeAreaInsets.leading + 6, geo.size.width * 0.03)
            let rightInset = max(geo.safeAreaInsets.trailing + 6, geo.size.width * 0.03)
            let topInset = max(geo.safeAreaInsets.top + 4, geo.size.height * 0.06)

            ZStack {
                Color.black
                    .ignoresSafeArea()

                HStack(alignment: .top, spacing: geo.size.width * 0.01) {
                    clockView(size: min(geo.size.width * 0.41, geo.size.height * 0.80))
                        .frame(width: geo.size.width * 0.77, alignment: .leading)

                    VStack(alignment: .leading, spacing: geo.size.height * 0.005) {
                        (
                            Text(weekdayString(from: now) + " ")
                                .foregroundColor(palette.top)
                            +
                            Text(dayNumber(from: now))
                                .foregroundColor(.white)
                        )
                        .font(.system(size: max(24, geo.size.width * 0.037), weight: .bold, design: .rounded))

                        Text(weatherManager.temperatureText)
                            .font(.system(size: max(24, geo.size.width * 0.036), weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(width: geo.size.width * 0.17, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, leftInset)
                .padding(.trailing, rightInset)
                .padding(.top, topInset)
            }
            .contentShape(Rectangle())
            .onTapGesture(count: 2) {
                standbyColorIndex = (standbyColorIndex + 1) % palettes.count
            }
        }
        .onAppear {
            wakeManager.forceAlwaysOnScreen = true
            wakeManager.keepScreenAwake = true
            wakeManager.applyCurrentSetting()
            weatherManager.start()
            displayedTime = clockString(from: now)
        }
        .onReceive(ticker) { tick in
            now = tick
            wakeManager.applyCurrentSetting()
            let newTime = clockString(from: tick)
            if newTime != displayedTime {
                withAnimation(.easeInOut(duration: 0.20)) {
                    displayedTime = newTime
                }
            }
            let second = Calendar.current.component(.second, from: tick)
            let minute = Calendar.current.component(.minute, from: tick)
            if second == 0 && minute % 15 == 0 {
                weatherManager.refresh()
            }
        }
    }

    private func clockString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "h:mm"
        return formatter.string(from: date)
    }

    private func weekdayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }

    private func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    @ViewBuilder
    private func clockView(size: CGFloat) -> some View {
        if let uiFont = standbyClockUIFont(size: size) {
            Text(displayedTime)
                .id(displayedTime)
                .font(Font(uiFont))
                .tracking(-1.2)
                .lineLimit(1)
                .minimumScaleFactor(0.50)
                .monospacedDigit()
                .foregroundStyle(
                    LinearGradient(
                        colors: [palette.top, palette.bottom],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.20), value: displayedTime)
        } else {
            StandbyClockText(
                text: displayedTime,
                topColor: palette.top,
                bottomColor: palette.bottom
            )
            .id(displayedTime)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.20), value: displayedTime)
        }
    }

    private func standbyClockUIFont(size: CGFloat) -> UIFont? {
        let names = [
            ".SFUIRounded-Heavy",
            ".SFUIRounded-Bold",
            ".SFUIRounded-Semibold",
            "SFUIRounded-Heavy",
            "SFUIRounded-Bold",
            "SFProRounded-Heavy",
            "SFProRounded-Bold",
            "SF Pro Rounded",
            "SFProDisplay-Heavy",
            "SFProDisplay-Bold"
        ]

        for name in names {
            if let font = UIFont(name: name, size: size) {
                return font
            }
        }
        return nil
    }
}

#Preview {
    StandbyView()
        .environmentObject(WakeManager())
        .preferredColorScheme(.dark)
}

private struct StandbyClockText: View {
    let text: String
    let topColor: Color
    let bottomColor: Color

    var body: some View {
        GeometryReader { geo in
            let glyphs = Array(text)
            let colonCount = glyphs.filter { $0 == ":" }.count
            let digitCount = max(1, glyphs.count - colonCount)
            let colonWidth = geo.size.width * 0.09
            let gap = geo.size.width * 0.015
            let digitWidth = max(10, (geo.size.width - (CGFloat(colonCount) * colonWidth) - (CGFloat(glyphs.count - 1) * gap)) / CGFloat(digitCount))

            HStack(alignment: .center, spacing: gap) {
                ForEach(Array(glyphs.enumerated()), id: \.offset) { _, char in
                    if char == ":" {
                        VStack(spacing: geo.size.height * 0.18) {
                            Circle()
                                .fill(gradient)
                                .frame(width: colonWidth * 0.80, height: colonWidth * 0.80)
                            Circle()
                                .fill(gradient)
                                .frame(width: colonWidth * 0.80, height: colonWidth * 0.80)
                        }
                        .frame(width: colonWidth, height: geo.size.height)
                    } else {
                        StandbyGlyphShape(symbol: char)
                            .stroke(
                                gradient,
                                style: StrokeStyle(
                                    lineWidth: digitWidth * 0.23,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                            .frame(width: digitWidth, height: geo.size.height)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [topColor, bottomColor],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

private struct StandbyGlyphShape: Shape {
    let symbol: Character

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: rect.minX + x * w, y: rect.minY + y * h)
        }

        switch symbol {
        case "0":
            path.addEllipse(in: CGRect(x: rect.minX + 0.18 * w, y: rect.minY + 0.08 * h, width: 0.64 * w, height: 0.84 * h))

        case "1":
            path.move(to: p(0.18, 0.24))
            path.addLine(to: p(0.48, 0.10))
            path.addLine(to: p(0.48, 0.90))

        case "2":
            path.move(to: p(0.20, 0.22))
            path.addLine(to: p(0.36, 0.10))
            path.addLine(to: p(0.76, 0.10))
            path.addLine(to: p(0.82, 0.30))
            path.addLine(to: p(0.28, 0.86))
            path.addLine(to: p(0.82, 0.86))

        case "3":
            path.move(to: p(0.24, 0.16))
            path.addLine(to: p(0.76, 0.16))
            path.addLine(to: p(0.56, 0.50))
            path.addLine(to: p(0.76, 0.84))
            path.addLine(to: p(0.24, 0.84))

        case "4":
            path.move(to: p(0.70, 0.10))
            path.addLine(to: p(0.70, 0.90))
            path.move(to: p(0.22, 0.54))
            path.addLine(to: p(0.78, 0.54))
            path.move(to: p(0.22, 0.54))
            path.addLine(to: p(0.58, 0.10))

        case "5":
            path.move(to: p(0.78, 0.14))
            path.addLine(to: p(0.30, 0.14))
            path.addLine(to: p(0.30, 0.50))
            path.addLine(to: p(0.76, 0.50))
            path.addLine(to: p(0.76, 0.86))
            path.addLine(to: p(0.24, 0.86))

        case "6":
            path.move(to: p(0.76, 0.16))
            path.addLine(to: p(0.34, 0.16))
            path.addLine(to: p(0.24, 0.34))
            path.addLine(to: p(0.24, 0.84))
            path.addLine(to: p(0.76, 0.84))
            path.addLine(to: p(0.76, 0.52))
            path.addLine(to: p(0.32, 0.52))

        case "7":
            path.move(to: p(0.20, 0.14))
            path.addLine(to: p(0.82, 0.14))
            path.addLine(to: p(0.42, 0.90))

        case "8":
            path.addEllipse(in: CGRect(x: rect.minX + 0.20 * w, y: rect.minY + 0.08 * h, width: 0.60 * w, height: 0.38 * h))
            path.addEllipse(in: CGRect(x: rect.minX + 0.20 * w, y: rect.minY + 0.52 * h, width: 0.60 * w, height: 0.38 * h))

        case "9":
            path.move(to: p(0.76, 0.48))
            path.addLine(to: p(0.24, 0.48))
            path.addLine(to: p(0.24, 0.16))
            path.addLine(to: p(0.76, 0.16))
            path.addLine(to: p(0.76, 0.86))

        default:
            break
        }

        return path
    }
}
