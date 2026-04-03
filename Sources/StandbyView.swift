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

                HStack(alignment: .top, spacing: 8) {
                    Text(clockString(from: now))
                        .font(
                            .system(
                                size: min(geo.size.width * 0.56, geo.size.height * 1.05),
                                weight: .black,
                                design: .rounded
                            )
                        )
                        .minimumScaleFactor(0.45)
                        .lineLimit(1)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.97, green: 0.49, blue: 0.45),
                                    Color(red: 0.86, green: 0.48, blue: 0.77)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .padding(.leading, max(18, geo.size.width * 0.035))
                        .padding(.top, max(18, geo.size.height * 0.06))

                    Spacer(minLength: 0)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(dayAndDateString(from: now))
                            .font(.system(size: max(26, geo.size.width * 0.030), weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.97, green: 0.49, blue: 0.45))

                        Text("31\u{00B0}C")
                            .font(.system(size: max(26, geo.size.width * 0.030), weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, max(20, geo.size.width * 0.045))
                    .padding(.top, max(36, geo.size.height * 0.11))
                }
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

    private func dayAndDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEE d"
        return formatter.string(from: date).uppercased()
    }
}

#Preview {
    StandbyView()
        .environmentObject(WakeManager())
        .preferredColorScheme(.dark)
}
