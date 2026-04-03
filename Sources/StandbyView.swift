import PhotosUI
import SwiftUI
import UIKit

private enum StandByPage: Int, CaseIterable, Identifiable {
    case clock
    case widgets
    case photos

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .clock: return "Clock"
        case .widgets: return "Widgets"
        case .photos: return "Photos"
        }
    }
}

private enum StandByColorTheme: String, CaseIterable, Identifiable {
    case crimson
    case orange
    case amber
    case lime
    case emerald
    case cyan
    case cobalt
    case indigo
    case violet
    case magenta
    case slate
    case mono

    var id: String { rawValue }

    var label: String {
        switch self {
        case .crimson: return "Crimson"
        case .orange: return "Orange"
        case .amber: return "Amber"
        case .lime: return "Lime"
        case .emerald: return "Emerald"
        case .cyan: return "Cyan"
        case .cobalt: return "Cobalt"
        case .indigo: return "Indigo"
        case .violet: return "Violet"
        case .magenta: return "Magenta"
        case .slate: return "Slate"
        case .mono: return "Mono"
        }
    }

    var primary: Color {
        switch self {
        case .crimson: return Color(red: 0.94, green: 0.18, blue: 0.26)
        case .orange: return Color(red: 0.98, green: 0.47, blue: 0.11)
        case .amber: return Color(red: 0.98, green: 0.74, blue: 0.13)
        case .lime: return Color(red: 0.71, green: 0.93, blue: 0.22)
        case .emerald: return Color(red: 0.20, green: 0.85, blue: 0.47)
        case .cyan: return Color(red: 0.15, green: 0.86, blue: 0.90)
        case .cobalt: return Color(red: 0.25, green: 0.53, blue: 0.96)
        case .indigo: return Color(red: 0.35, green: 0.36, blue: 0.96)
        case .violet: return Color(red: 0.62, green: 0.33, blue: 0.95)
        case .magenta: return Color(red: 0.97, green: 0.26, blue: 0.81)
        case .slate: return Color(red: 0.56, green: 0.65, blue: 0.72)
        case .mono: return Color(red: 0.93, green: 0.93, blue: 0.93)
        }
    }

    var secondary: Color {
        switch self {
        case .crimson: return Color(red: 1.00, green: 0.37, blue: 0.42)
        case .orange: return Color(red: 1.00, green: 0.61, blue: 0.22)
        case .amber: return Color(red: 1.00, green: 0.84, blue: 0.33)
        case .lime: return Color(red: 0.83, green: 0.98, blue: 0.42)
        case .emerald: return Color(red: 0.38, green: 0.94, blue: 0.62)
        case .cyan: return Color(red: 0.36, green: 0.95, blue: 0.98)
        case .cobalt: return Color(red: 0.44, green: 0.67, blue: 0.99)
        case .indigo: return Color(red: 0.50, green: 0.51, blue: 1.00)
        case .violet: return Color(red: 0.75, green: 0.52, blue: 0.99)
        case .magenta: return Color(red: 1.00, green: 0.40, blue: 0.88)
        case .slate: return Color(red: 0.71, green: 0.79, blue: 0.84)
        case .mono: return Color(red: 1.00, green: 1.00, blue: 1.00)
        }
    }

    var background: [Color] {
        switch self {
        case .crimson:
            return [Color(red: 0.19, green: 0.02, blue: 0.05), Color(red: 0.08, green: 0.01, blue: 0.02), .black]
        case .orange:
            return [Color(red: 0.20, green: 0.07, blue: 0.01), Color(red: 0.09, green: 0.03, blue: 0.01), .black]
        case .amber:
            return [Color(red: 0.16, green: 0.11, blue: 0.00), Color(red: 0.09, green: 0.06, blue: 0.00), .black]
        case .lime:
            return [Color(red: 0.06, green: 0.13, blue: 0.01), Color(red: 0.03, green: 0.07, blue: 0.01), .black]
        case .emerald:
            return [Color(red: 0.02, green: 0.13, blue: 0.06), Color(red: 0.01, green: 0.06, blue: 0.03), .black]
        case .cyan:
            return [Color(red: 0.01, green: 0.12, blue: 0.14), Color(red: 0.01, green: 0.05, blue: 0.07), .black]
        case .cobalt:
            return [Color(red: 0.02, green: 0.08, blue: 0.18), Color(red: 0.01, green: 0.04, blue: 0.09), .black]
        case .indigo:
            return [Color(red: 0.04, green: 0.04, blue: 0.18), Color(red: 0.02, green: 0.02, blue: 0.09), .black]
        case .violet:
            return [Color(red: 0.10, green: 0.03, blue: 0.18), Color(red: 0.05, green: 0.01, blue: 0.09), .black]
        case .magenta:
            return [Color(red: 0.18, green: 0.02, blue: 0.14), Color(red: 0.08, green: 0.01, blue: 0.06), .black]
        case .slate:
            return [Color(red: 0.06, green: 0.08, blue: 0.10), Color(red: 0.03, green: 0.04, blue: 0.05), .black]
        case .mono:
            return [Color(red: 0.11, green: 0.11, blue: 0.11), Color(red: 0.05, green: 0.05, blue: 0.05), .black]
        }
    }
}

struct StandbyView: View {
    @EnvironmentObject private var wakeManager: WakeManager

    @AppStorage("use24HourClock") private var use24HourClock: Bool = true
    @AppStorage("showSeconds") private var showSeconds: Bool = false
    @AppStorage("dimmerOpacity") private var dimmerOpacity: Double = 0.16
    @AppStorage("enableNightModeTint") private var enableNightModeTint: Bool = true
    @AppStorage("autoNightModeTint") private var autoNightModeTint: Bool = true
    @AppStorage("lastStandByPage") private var lastStandByPage: Int = StandByPage.clock.rawValue
    @AppStorage("standByColorTheme") private var standByColorTheme: String = StandByColorTheme.crimson.rawValue

    @StateObject private var motionManager = StandbyMotionManager()
    @State private var now: Date = Date()
    @State private var showControls: Bool = false
    @State private var pageSelection: Int = StandByPage.clock.rawValue
    @State private var batteryPercentText: String = "--%"
    @State private var isCharging: Bool = false
    @State private var burnInOffset: CGSize = .zero
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var selectedPhotos: [UIImage] = []
    @State private var currentPhotoIndex: Int = 0
    @State private var controlsAutoHideTask: Task<Void, Never>?

    private let clockTicker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let burnInTicker = Timer.publish(every: 70, on: .main, in: .common).autoconnect()
    private let slideshowTicker = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

    private var selectedTheme: StandByColorTheme {
        StandByColorTheme(rawValue: standByColorTheme) ?? .crimson
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundView

                TabView(selection: $pageSelection) {
                    clockPage(in: geometry.size)
                        .tag(StandByPage.clock.rawValue)

                    widgetsPage
                        .tag(StandByPage.widgets.rawValue)

                    photosPage
                        .tag(StandByPage.photos.rawValue)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .offset(
                    x: burnInOffset.width + motionManager.roll * 10,
                    y: burnInOffset.height + motionManager.pitch * 8
                )
                .animation(.easeInOut(duration: 0.9), value: burnInOffset)
                .overlay(alignment: .top) {
                    topPageLabel
                }

                Color.black
                    .opacity(dimmerOpacity)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                if isNightTintActive {
                    selectedTheme.primary
                        .opacity(max(0.08, dimmerOpacity * 0.75))
                        .blendMode(.plusLighter)
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                }

                if showControls {
                    controlsPanel
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                toggleControls()
            }
        }
        .onAppear {
            pageSelection = lastStandByPage
            wakeManager.forceAlwaysOnScreen = true
            wakeManager.keepScreenAwake = true
            wakeManager.applyCurrentSetting()
            refreshBatteryInfo()
            motionManager.start()
            scheduleControlsAutoHide()
        }
        .onDisappear {
            controlsAutoHideTask?.cancel()
            controlsAutoHideTask = nil
            motionManager.stop()
        }
        .onChange(of: pageSelection) { newValue in
            lastStandByPage = newValue
            scheduleControlsAutoHide()
        }
        .onChange(of: photoItems) { items in
            Task {
                await loadPhotos(from: items)
            }
        }
        .onReceive(clockTicker) { value in
            now = value
            refreshBatteryInfo()
        }
        .onReceive(slideshowTicker) { _ in
            guard pageSelection == StandByPage.photos.rawValue else { return }
            guard selectedPhotos.count > 1 else { return }
            withAnimation(.easeInOut(duration: 0.6)) {
                currentPhotoIndex = (currentPhotoIndex + 1) % selectedPhotos.count
            }
        }
        .onReceive(burnInTicker) { _ in
            guard !showControls else { return }
            withAnimation(.easeInOut(duration: 1.2)) {
                burnInOffset = CGSize(
                    width: Double.random(in: -5...5),
                    height: Double.random(in: -4...4)
                )
            }
        }
    }

    private var backgroundView: some View {
        LinearGradient(
            colors: selectedTheme.background,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var topPageLabel: some View {
        HStack(spacing: 8) {
            ForEach(StandByPage.allCases) { page in
                Circle()
                    .fill(pageSelection == page.rawValue ? selectedTheme.secondary : Color.white.opacity(0.25))
                    .frame(width: pageSelection == page.rawValue ? 8 : 6, height: pageSelection == page.rawValue ? 8 : 6)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
        .padding(.top, 12)
    }

    private func clockPage(in size: CGSize) -> some View {
        VStack(spacing: 14) {
            Spacer()

            Text(timeString(from: now))
                .font(.system(size: min(size.width, size.height) * 0.45, weight: .bold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.35)
                .foregroundStyle(selectedTheme.secondary)
                .shadow(color: selectedTheme.primary.opacity(0.35), radius: 10, x: 0, y: 0)

            Text(dateString(from: now))
                .font(.system(size: min(size.width, size.height) * 0.09, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.82))

            HStack(spacing: 14) {
                statusPill(text: "Battery \(batteryPercentText)")
                statusPill(text: isCharging ? "Charging" : "Not Charging")
            }

            Spacer()
        }
        .padding(.horizontal, 24)
    }

    private var widgetsPage: some View {
        HStack(spacing: 14) {
            VStack(spacing: 14) {
                widgetCard(title: "Date", content: dateShortString(from: now), subtitle: weekdayString(from: now))
                widgetCard(title: "Time", content: timeString(from: now), subtitle: use24HourClock ? "24-hour" : "12-hour")
            }

            VStack(spacing: 14) {
                widgetCard(title: "Battery", content: batteryPercentText, subtitle: isCharging ? "Charging" : "On Battery")
                widgetCard(title: "Screen", content: "Always On", subtitle: "Active in app")
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private var photosPage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(selectedTheme.primary.opacity(0.35), lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

            if let image = selectedPhotos[safe: currentPhotoIndex] {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .transition(.opacity)
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "photo.stack")
                        .font(.system(size: 40, weight: .regular))
                        .foregroundColor(selectedTheme.secondary.opacity(0.95))
                    Text("Add photos from controls")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.84))
                    Text("Tap screen to open controls")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.58))
                }
            }
        }
    }

    private var controlsPanel: some View {
        VStack {
            HStack {
                Spacer()
                Button("Hide") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showControls = false
                    }
                }
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Color.white.opacity(0.14))
                .clipShape(Capsule())
            }
            .padding([.top, .horizontal], 16)

            Spacer()

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    ForEach(StandByPage.allCases) { page in
                        Button(page.title) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                pageSelection = page.rawValue
                            }
                        }
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(pageSelection == page.rawValue ? selectedTheme.primary.opacity(0.38) : Color.white.opacity(0.10))
                        .clipShape(Capsule())
                    }
                }

                Text("Color")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.72))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(StandByColorTheme.allCases) { theme in
                            Button {
                                standByColorTheme = theme.rawValue
                            } label: {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [theme.secondary, theme.primary],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                standByColorTheme == theme.rawValue ? Color.white : Color.white.opacity(0.25),
                                                lineWidth: standByColorTheme == theme.rawValue ? 2.5 : 1
                                            )
                                    )
                                    .frame(width: 28, height: 28)
                            }
                            .accessibilityLabel(theme.label)
                        }
                    }
                    .padding(.vertical, 2)
                }

                Label("Always-on screen enabled", systemImage: "lock.fill")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(selectedTheme.secondary)

                Toggle("24-hour clock", isOn: $use24HourClock)
                Toggle("Show seconds", isOn: $showSeconds)
                Toggle("Night mode tint", isOn: $enableNightModeTint)
                Toggle("Auto night mode", isOn: $autoNightModeTint)

                HStack {
                    Text("Dimmer")
                    Slider(value: $dimmerOpacity, in: 0...0.92)
                }

                PhotosPicker(selection: $photoItems, maxSelectionCount: 24, matching: .images) {
                    Text("Choose Photos")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedTheme.primary.opacity(0.30))
                        .clipShape(Capsule())
                }
            }
            .tint(selectedTheme.secondary)
            .font(.system(size: 15, weight: .medium, design: .rounded))
            .foregroundColor(.white)
            .padding(14)
            .background(Color.black.opacity(0.58))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(selectedTheme.primary.opacity(0.35), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private var isNightTintActive: Bool {
        guard enableNightModeTint else { return false }
        if !autoNightModeTint { return true }
        let hour = Calendar.current.component(.hour, from: now)
        return hour >= 22 || hour <= 6
    }

    private func refreshBatteryInfo() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        batteryPercentText = level >= 0 ? "\(Int(level * 100))%" : "--%"
        isCharging = UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full
    }

    private func toggleControls() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showControls.toggle()
        }
        if showControls {
            scheduleControlsAutoHide()
        } else {
            controlsAutoHideTask?.cancel()
            controlsAutoHideTask = nil
        }
    }

    private func scheduleControlsAutoHide() {
        controlsAutoHideTask?.cancel()
        controlsAutoHideTask = Task {
            try? await Task.sleep(nanoseconds: 7_000_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showControls = false
                }
            }
        }
    }

    private func loadPhotos(from items: [PhotosPickerItem]) async {
        var loadedPhotos: [UIImage] = []
        for item in items {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                continue
            }
            loadedPhotos.append(image)
        }

        await MainActor.run {
            selectedPhotos = loadedPhotos
            currentPhotoIndex = 0
        }
    }

    private func widgetCard(title: String, content: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.65))
            Spacer()
            Text(content)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundColor(selectedTheme.secondary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(subtitle)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.74))
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(selectedTheme.primary.opacity(0.35), lineWidth: 1)
        )
    }

    private func statusPill(text: String) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(selectedTheme.primary.opacity(0.24))
            .foregroundColor(selectedTheme.secondary)
            .clipShape(Capsule())
    }

    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = use24HourClock ? (showSeconds ? "HH:mm:ss" : "HH:mm") : (showSeconds ? "h:mm:ss" : "h:mm")
        return formatter.string(from: date)
    }

    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }

    private func weekdayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    private func dateShortString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

#Preview {
    StandbyView()
        .environmentObject(WakeManager())
        .preferredColorScheme(.dark)
}
