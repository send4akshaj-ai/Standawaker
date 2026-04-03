import CoreLocation
import Foundation

final class WeatherManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var temperatureText: String = "29\u{00B0}C"

    private let locationManager = CLLocationManager()
    private var lastLocation: CLLocation?
    private var lastFetch: Date?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func start() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
    }

    func refresh() {
        guard locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse else {
            return
        }
        locationManager.requestLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        Task {
            await fetchTemperature(for: location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError _: Error) {
        if let cached = lastLocation {
            Task {
                await fetchTemperature(for: cached.coordinate)
            }
        }
    }

    private func fetchTemperature(for coordinate: CLLocationCoordinate2D) async {
        if let lastFetch, Date().timeIntervalSince(lastFetch) < 120 {
            return
        }

        let lat = coordinate.latitude
        let lon = coordinate.longitude
        let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m&timezone=auto"
        guard let url = URL(string: endpoint) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let parsed = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
            if let value = parsed.current.temperature2m {
                let rounded = Int(value.rounded())
                await MainActor.run {
                    self.temperatureText = "\(rounded)\u{00B0}C"
                }
                lastFetch = Date()
            }
        } catch {
            return
        }
    }
}

private struct OpenMeteoResponse: Decodable {
    struct Current: Decodable {
        let temperature2m: Double?

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
        }
    }

    let current: Current
}
