import SwiftUI

struct StandbyView: View {
    @EnvironmentObject private var wakeManager: WakeManager

    @State private var now = Date()
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                    .ignoresSafeArea()

                Text(clockString(from: now))
                    .font(
                        .system(
                            size: min(geo.size.width * 0.47, geo.size.height * 0.83),
                            weight: .black,
                            design: .rounded
                        )
                    )
                    .tracking(-4)
                    .lineLimit(1)
                    .minimumScaleFactor(0.45)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.97, green: 0.48, blue: 0.44),
                                Color(red: 0.86, green: 0.47, blue: 0.78)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading, geo.size.width * 0.15)
                    .padding(.top, geo.size.height * 0.08)

                VStack(alignment: .leading, spacing: 2) {
                    (
                        Text(weekdayString(from: now) + " ")
                            .foregroundColor(Color(red: 0.97, green: 0.48, blue: 0.44))
                        +
                        Text(dayNumber(from: now))
                            .foregroundColor(.white)
                    )
                    .font(.system(size: max(26, geo.size.width * 0.045), weight: .bold, design: .rounded))

                    Text("31\u{00B0}C")
                        .font(.system(size: max(24, geo.size.width * 0.043), weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.trailing, geo.size.width * 0.08)
                .padding(.top, geo.size.height * 0.14)
            }
        }
        .onAppear {
            wakeManager.forceAlwaysOnScreen = true
            wakeManager.keepScreenAwake = true
            wakeManager.applyCurrentSetting()
        }
        .onReceive(ticker) { tick in
            now = tick
            wakeManager.applyCurrentSetting()
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
}

#Preview {
    StandbyView()
        .environmentObject(WakeManager())
        .preferredColorScheme(.dark)
}
