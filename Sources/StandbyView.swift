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
                    Text(displayedTime)
                        .id(displayedTime)
                        .font(standbyClockFont(size: min(geo.size.width * 0.41, geo.size.height * 0.80)))
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

    private func standbyClockFont(size: CGFloat) -> Font {
        let candidates = [
            "SFProDisplay-Heavy",
            "SFProDisplay-Bold",
            "SF Pro Display"
        ]
        for name in candidates {
            if let font = UIFont(name: name, size: size) {
                return Font(font)
            }
        }
        return .system(size: size, weight: .heavy, design: .default)
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
}

#Preview {
    StandbyView()
        .environmentObject(WakeManager())
        .preferredColorScheme(.dark)
}
