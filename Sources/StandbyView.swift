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
            ZStack {
                Color.black
                    .ignoresSafeArea()

                HStack(spacing: 0) {
                    Text(clockString(from: now))
                        .font(standbyClockFont(size: min(geo.size.width * 0.44, geo.size.height * 0.82)))
                        .tracking(-3)
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                    Color.clear
                        .frame(width: geo.size.width * 0.22)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: -geo.size.width * 0.05, y: geo.size.height * 0.005)

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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.trailing, geo.size.width * 0.055)
                .padding(.top, geo.size.height * 0.13)
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
        }
        .onReceive(ticker) { tick in
            now = tick
            wakeManager.applyCurrentSetting()
            let second = Calendar.current.component(.second, from: tick)
            let minute = Calendar.current.component(.minute, from: tick)
            if second == 0 && minute % 15 == 0 {
                weatherManager.refresh()
            }
        }
    }

    private func standbyClockFont(size: CGFloat) -> Font {
        let base = UIFont.systemFont(ofSize: size, weight: .bold)
        if let roundedDescriptor = base.fontDescriptor.withDesign(.rounded) {
            return Font(UIFont(descriptor: roundedDescriptor, size: size))
        }
        return .system(size: size, weight: .bold, design: .rounded)
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
