import PhotosUI
import SwiftUI
import UIKit

private enum StandByPage: Int, CaseIterable, Identifiable {
    case widgets
    case clock
    case photos

    var id: Int { rawValue }
}

private enum ClockLayout: String, CaseIterable, Identifiable {
    case full
    case stacked
    case minimal

    var id: String { rawValue }

    var title: String {
        switch self {
        case .full: return "Full"
        case .stacked: return "Stacked"
        case .minimal: return "Minimal"
        }
    }
}

private enum StandByTheme: String, CaseIterable, Identifiable {
    case standbyRed
    case glowOrange
    case solarAmber
    case neonLime
    case appleGreen
    case aqua
    case cobalt
    case ultraViolet
    case orchid
    case rose
    case slate
    case mono

    var id: String { rawValue }

    var name: String {
        switch self {
        case .standbyRed: return "StandBy Red"
        case .glowOrange: return "Glow Orange"
        case .solarAmber: return "Solar Amber"
        case .neonLime: return "Neon Lime"
        case .appleGreen: return "Apple Green"
        case .aqua: return "Aqua"
        case .cobalt: return "Cobalt"
        case .ultraViolet: return "Ultra Violet"
        case .orchid: return "Orchid"
        case .rose: return "Rose"
        case .slate: return "Slate"
        case .mono: return "Mono"
        }
    }

    var accent: Color {
        switch self {
        case .standbyRed: return Color(red: 1.0, green: 0.19, blue: 0.24)
        case .glowOrange: return Color(red: 0.99, green: 0.49, blue: 0.08)
        case .solarAmber: return Color(red: 0.98, green: 0.75, blue: 0.16)
        case .neonLime: return Color(red: 0.78, green: 0.98, blue: 0.26)
        case .appleGreen: return Color(red: 0.22, green: 0.90, blue: 0.48)
        case .aqua: return Color(red: 0.17, green: 0.88, blue: 0.94)
        case .cobalt: return Color(red: 0.28, green: 0.55, blue: 1.0)
        case .ultraViolet: return Color(red: 0.55, green: 0.40, blue: 1.0)
        case .orchid: return Color(red: 0.82, green: 0.40, blue: 0.97)
        case .rose: return Color(red: 0.98, green: 0.32, blue: 0.62)
        case .slate: return Color(red: 0.70, green: 0.76, blue: 0.82)
        case .mono: return Color(red: 0.97, green: 0.97, blue: 0.97)
        }
    }

    var secondaryAccent: Color {
        switch self {
        case .standbyRed: return Color(red: 1.0, green: 0.39, blue: 0.43)
        case .glowOrange: return Color(red: 1.0, green: 0.67, blue: 0.30)
        case .solarAmber: return Color(red: 1.0, green: 0.88, blue: 0.38)
        case .neonLime: return Color(red: 0.89, green: 1.0, blue: 0.50)
        case .appleGreen: return Color(red: 0.48, green: 0.97, blue: 0.67)
        case .aqua: return Color(red: 0.45, green: 0.97, blue: 0.99)
        case .cobalt: return Color(red: 0.52, green: 0.72, blue: 1.0)
        case .ultraViolet: return Color(red: 0.69, green: 0.57, blue: 1.0)
        case .orchid: return Color(red: 0.92, green: 0.57, blue: 1.0)
        case .rose: return Color(red: 1.0, green: 0.51, blue: 0.76)
        case .slate: return Color(red: 0.80, green: 0.86, blue: 0.90)
        case .mono: return .white
        }
    }

    var background: [Color] {
        switch self {
        case .standbyRed:
            return [Color(red: 0.15, green: 0.01, blue: 0.03), Color(red: 0.08, green: 0.01, blue: 0.02), .black]
        case .glowOrange:
            return [Color(red: 0.17, green: 0.06, blue: 0.01), Color(red: 0.08, green: 0.03, blue: 0.01), .black]
        case .solarAmber:
            return [Color(red: 0.15, green: 0.11, blue: 0.01), Color(red: 0.07, green: 0.05, blue: 0.01), .black]
        case .neonLime:
            return [Color(red: 0.06, green: 0.12, blue: 0.01), Color(red: 0.03, green: 0.06, blue: 0.01), .black]
        case .appleGreen:
            return [Color(red: 0.01, green: 0.12, blue: 0.05), Color(red: 0.01, green: 0.06, blue: 0.03), .black]
        case .aqua:
            return [Color(red: 0.01, green: 0.12, blue: 0.13), Color(red: 0.01, green: 0.05, blue: 0.06), .black]
        case .cobalt:
            return [Color(red: 0.02, green: 0.07, blue: 0.18), Color(red: 0.01, green: 0.03, blue: 0.09), .black]
        case .ultraViolet:
            return [Color(red: 0.06, green: 0.03, blue: 0.18), Color(red: 0.03, green: 0.01, blue: 0.09), .black]
        case .orchid:
            return [Color(red: 0.12, green: 0.02, blue: 0.16), Color(red: 0.06, green: 0.01, blue: 0.08), .black]
        case .rose:
            return [Color(red: 0.15, green: 0.02, blue: 0.09), Color(red: 0.07, green: 0.01, blue: 0.04), .black]
        case .slate:
            return [Color(red: 0.06, green: 0.08, blue: 0.10), Color(red: 0.03, green: 0.04, blue: 0.05), .black]
        case .mono:
            return [Color(red: 0.10, green: 0.10, blue: 0.10), Color(red: 0.05, green: 0.05, blue: 0.05), .black]
        }
    }
}

struct StandbyView: View {
    @EnvironmentObject private var wakeManager: WakeManager

    @AppStorage("use24HourClock") private var use24HourClock: Bool = true
    @AppStorage("showSeconds") private var showSeconds: Bool = true
    @AppStorage("dimmerOpacity") private var dimmerOpacity: Double = 0.18
    @AppStorage("enableNightModeTint") private var enableNightModeTint: Bool = true
    @AppStorage("autoNightModeTint") private var autoNightModeTint: Bool = true
    @AppStorage("standByTheme") private var standByThemeRaw: String = StandByTheme.standbyRed.rawValue
    @AppStorage("clockLayout") private var clockLayoutRaw: String = ClockLayout.full.rawValue
    @AppStorage("lastStandByPage") private var lastStandByPage: Int = StandByPage.widgets.rawValue

    @StateObject private var motionManager = StandbyMotionManager()
    @State private var now = Date()
    @State private var pageSelection = StandByPage.widgets.rawValue
    @State private var showControls = false
    @State private var batteryPercentText = "--%"
    @State private var isCharging = false
    @State private var burnInOffset: CGSize = .zero
    @State private var photoItems: [PhotosPickerItem] = []
    @State private var selectedPhotos: [UIImage] = []
    @State private var currentPhotoIndex = 0
    @State private var controlsAutoHideTask: Task<Void, Never>?
    @State private var photosZoomPulse = false

    private let secondTicker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let burnInTicker = Timer.publish(every: 55, on: .main, in: .common).autoconnect()
    private let slideshowTicker = Timer.publish(every: 9, on: .main, in: .common).autoconnect()
    private let glowTicker = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()

    private var theme: StandByTheme {
        StandByTheme(rawValue: standByThemeRaw) ?? .standbyRed
    }

    private var clockLayout: ClockLayout {
        ClockLayout(rawValue: clockLayoutRaw) ?? .full
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundLayer

                TabView(selection: $pageSelection) {
                    widgetsReplicaPage(in: geometry.size)
                        .tag(StandByPage.widgets.rawValue)

                    fullClockReplicaPage(in: geometry.size)
                        .tag(StandByPage.clock.rawValue)

                    photoReplicaPage
                        .tag(StandByPage.photos.rawValue)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .offset(x: burnInOffset.width + motionManager.roll * 9, y: burnInOffset.height + motionManager.pitch * 7)
                .animation(.easeInOut(duration: 1.0), value: burnInOffset)
                .overlay(alignment: .trailing) {
                    sidePageIndicator
                        .padding(.trailing, 10)
                }

                Color.black
                    .opacity(dimmerOpacity)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                if isNightTintActive {
                    theme.accent
                        .opacity(max(0.10, dimmerOpacity * 0.72))
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
            refreshBattery()
            motionManager.start()
            scheduleControlsAutoHide()
        }
        .onDisappear {
            controlsAutoHideTask?.cancel()
            controlsAutoHideTask = nil
            motionManager.stop()
        }
        .onChange(of: photoItems) { items in
            Task { await loadPhotos(from: items) }
        }
        .onChange(of: pageSelection) { newPage in
            lastStandByPage = newPage
            scheduleControlsAutoHide()
        }
        .onReceive(secondTicker) { tick in
            now = tick
            refreshBattery()
            wakeManager.applyCurrentSetting()
        }
        .onReceive(slideshowTicker) { _ in
            guard pageSelection == StandByPage.photos.rawValue else { return }
            guard selectedPhotos.count > 1 else { return }
            withAnimation(.easeInOut(duration: 0.8)) {
                currentPhotoIndex = (currentPhotoIndex + 1) % selectedPhotos.count
                photosZoomPulse.toggle()
            }
        }
        .onReceive(burnInTicker) { _ in
            guard !showControls else { return }
            withAnimation(.easeInOut(duration: 1.5)) {
                burnInOffset = CGSize(width: Double.random(in: -4...4), height: Double.random(in: -3...3))
            }
        }
        .onReceive(glowTicker) { _ in
            withAnimation(.easeInOut(duration: 1.4)) {
                photosZoomPulse.toggle()
            }
        }
    }

    private var backgroundLayer: some View {
        ZStack {
            LinearGradient(colors: theme.background, startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            RadialGradient(
                colors: [theme.accent.opacity(0.22), .clear],
                center: .center,
                startRadius: 24,
                endRadius: 430
            )
            .ignoresSafeArea()
        }
    }

    private func widgetsReplicaPage(in size: CGSize) -> some View {
        let columnSpacing = max(12, size.width * 0.018)

        return HStack(spacing: columnSpacing) {
            VStack(spacing: columnSpacing) {
                standbyCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(monthHeader(from: now))
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(theme.secondaryAccent.opacity(0.92))
                        Spacer(minLength: 0)
                        Text(dayNumber(from: now))
                            .font(.system(size: min(size.width, size.height) * 0.20, weight: .bold, design: .rounded))
                            .foregroundColor(theme.secondaryAccent)
                        Text(weekdayName(from: now))
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.80))
                    }
                }

                standbyCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("NEXT")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.58))
                        Spacer(minLength: 0)
                        Label("No Alarms", systemImage: "alarm")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.88))
                        Text("Add alarms in Clock app")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.60))
                    }
                }
            }

            VStack(spacing: columnSpacing) {
                standbyCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("TIME")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.58))
                        Spacer(minLength: 0)
                        Text(timeString(from: now, seconds: false))
                            .font(.system(size: min(size.width, size.height) * 0.22, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(theme.secondaryAccent)
                            .shadow(color: theme.accent.opacity(0.34), radius: 12, x: 0, y: 0)
                    }
                }

                standbyCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("BATTERY")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.58))
                        Spacer(minLength: 0)
                        Text(batteryPercentText)
                            .font(.system(size: min(size.width, size.height) * 0.13, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(theme.secondaryAccent)
                        Label(isCharging ? "Charging" : "On Battery", systemImage: isCharging ? "bolt.fill" : "battery.75")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.78))
                    }
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 20)
    }

    private func fullClockReplicaPage(in size: CGSize) -> some View {
        VStack(spacing: 12) {
            Spacer(minLength: size.height * 0.06)

            switch clockLayout {
            case .full:
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(hourString(from: now))
                        .font(.system(size: min(size.width, size.height) * 0.48, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(theme.secondaryAccent)
                    Text(":")
                        .font(.system(size: min(size.width, size.height) * 0.47, weight: .bold, design: .rounded))
                        .opacity(colonVisible ? 1.0 : 0.48)
                        .foregroundStyle(theme.secondaryAccent)
                    Text(minuteString(from: now))
                        .font(.system(size: min(size.width, size.height) * 0.48, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(theme.secondaryAccent)
                }
                .shadow(color: theme.accent.opacity(0.36), radius: 18, x: 0, y: 0)

            case .stacked:
                VStack(spacing: -4) {
                    Text(hourString(from: now))
                        .font(.system(size: min(size.width, size.height) * 0.41, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(theme.secondaryAccent)
                    Text(minuteString(from: now))
                        .font(.system(size: min(size.width, size.height) * 0.41, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(theme.secondaryAccent)
                }
                .shadow(color: theme.accent.opacity(0.36), radius: 16, x: 0, y: 0)

            case .minimal:
                Text(timeString(from: now, seconds: false))
                    .font(.system(size: min(size.width, size.height) * 0.34, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(theme.secondaryAccent)
                    .shadow(color: theme.accent.opacity(0.33), radius: 12, x: 0, y: 0)
            }

            if showSeconds {
                Text(secondString(from: now))
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(.white.opacity(0.66))
            }

            if !use24HourClock {
                Text(meridiem(from: now))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.72))
            }

            Text(dateLongString(from: now))
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.80))

            Spacer()
        }
        .padding(.horizontal, 20)
    }

    private var photoReplicaPage: some View {
        ZStack {
            if let image = selectedPhotos[safe: currentPhotoIndex] {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(photosZoomPulse ? 1.06 : 1.01)
                    .animation(.easeInOut(duration: 8), value: photosZoomPulse)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .padding(14)
                    .overlay(alignment: .bottomLeading) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(timeString(from: now, seconds: false))
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .foregroundStyle(.white)
                            Text(dateLongString(from: now))
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.86))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 22)
                    }
            } else {
                standbyCard {
                    VStack(spacing: 12) {
                        Image(systemName: "photo.stack")
                            .font(.system(size: 46, weight: .regular))
                            .foregroundColor(theme.secondaryAccent.opacity(0.95))
                        Text("Add photos from controls")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.84))
                        Text("Tap screen, then choose photos")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.58))
                    }
                }
                .padding(14)
            }
        }
    }

    private var sidePageIndicator: some View {
        VStack(spacing: 7) {
            ForEach(StandByPage.allCases) { page in
                Capsule()
                    .fill(pageSelection == page.rawValue ? theme.secondaryAccent : Color.white.opacity(0.22))
                    .frame(width: 4, height: pageSelection == page.rawValue ? 20 : 10)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.35), in: Capsule())
    }

    private var controlsPanel: some View {
        VStack {
            HStack {
                Spacer()
                Button("Close") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showControls = false
                    }
                }
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Color.white.opacity(0.14), in: Capsule())
            }
            .padding([.top, .horizontal], 14)

            Spacer()

            VStack(alignment: .leading, spacing: 11) {
                HStack(spacing: 8) {
                    quickPageButton(title: "Widgets", page: .widgets)
                    quickPageButton(title: "Clock", page: .clock)
                    quickPageButton(title: "Photos", page: .photos)
                }

                Text("Themes")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.72))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(StandByTheme.allCases) { candidate in
                            Button {
                                standByThemeRaw = candidate.rawValue
                            } label: {
                                VStack(spacing: 4) {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [candidate.secondaryAccent, candidate.accent],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 26, height: 26)
                                        .overlay(
                                            Circle().stroke(standByThemeRaw == candidate.rawValue ? Color.white : Color.white.opacity(0.25), lineWidth: standByThemeRaw == candidate.rawValue ? 2.0 : 1.0)
                                        )
                                    Text(candidate.name)
                                        .font(.system(size: 10, weight: .medium, design: .rounded))
                                        .foregroundColor(.white.opacity(0.66))
                                }
                            }
                        }
                    }
                    .padding(.vertical, 2)
                }

                HStack {
                    Text("Clock Layout")
                    Spacer()
                    Picker("Clock Layout", selection: $clockLayoutRaw) {
                        ForEach(ClockLayout.allCases) { style in
                            Text(style.title).tag(style.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 220)
                }

                Toggle("Always-on while app is open", isOn: $wakeManager.forceAlwaysOnScreen)
                Toggle("24-hour clock", isOn: $use24HourClock)
                Toggle("Show seconds", isOn: $showSeconds)
                Toggle("Night tint", isOn: $enableNightModeTint)
                Toggle("Auto night tint", isOn: $autoNightModeTint)

                HStack {
                    Text("Dimmer")
                    Slider(value: $dimmerOpacity, in: 0...0.95)
                }

                PhotosPicker(selection: $photoItems, maxSelectionCount: 30, matching: .images) {
                    Label("Choose Photos", systemImage: "photo.on.rectangle.angled")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(theme.accent.opacity(0.36), in: Capsule())
                }
            }
            .tint(theme.secondaryAccent)
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .padding(14)
            .background(Color.black.opacity(0.60), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(theme.accent.opacity(0.45), lineWidth: 1)
            )
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private func quickPageButton(title: String, page: StandByPage) -> some View {
        Button(title) {
            withAnimation(.easeInOut(duration: 0.25)) {
                pageSelection = page.rawValue
            }
        }
        .font(.system(size: 13, weight: .bold, design: .rounded))
        .padding(.horizontal, 11)
        .padding(.vertical, 6)
        .background(pageSelection == page.rawValue ? theme.accent.opacity(0.44) : Color.white.opacity(0.10), in: Capsule())
    }

    private func standbyCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(theme.accent.opacity(0.32), lineWidth: 1)
            )
    }

    private var colonVisible: Bool {
        Calendar.current.component(.second, from: now).isMultiple(of: 2)
    }

    private var isNightTintActive: Bool {
        guard enableNightModeTint else { return false }
        if !autoNightModeTint { return true }
        let hour = Calendar.current.component(.hour, from: now)
        return hour >= 22 || hour <= 6
    }

    private func refreshBattery() {
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
        var loaded: [UIImage] = []
        for item in items {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                continue
            }
            loaded.append(image)
        }

        await MainActor.run {
            selectedPhotos = loaded
            currentPhotoIndex = 0
        }
    }

    private func timeString(from date: Date, seconds: Bool) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = use24HourClock
            ? (seconds ? "HH:mm:ss" : "HH:mm")
            : (seconds ? "h:mm:ss" : "h:mm")
        return formatter.string(from: date)
    }

    private func hourString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = use24HourClock ? "HH" : "h"
        return formatter.string(from: date)
    }

    private func minuteString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "mm"
        return formatter.string(from: date)
    }

    private func secondString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "ss"
        return formatter.string(from: date)
    }

    private func meridiem(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "a"
        return formatter.string(from: date)
    }

    private func dateLongString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }

    private func weekdayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    private func monthHeader(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date).uppercased()
    }

    private func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d"
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
