import Foundation
import CoreLocation

struct WeatherData: Codable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Codable {
    let name: String
    let country: String
}

struct CurrentWeather: Codable {
    let temp_c: Double
    let temp_f: Double
    let condition: WeatherCondition
}

struct WeatherCondition: Codable {
    let text: String
    let code: Int
}

class WeatherManager {
    let apiKey = "b520bdbdc5344849bc3223001252903"
    let baseUrl = "https://api.weatherapi.com/v1/current.json?key="

    func fetchWeather(for city: String, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "\(baseUrl)\(apiKey)&q=\(city)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        completion(weatherData)
                    }
                } catch {
                    print("Error decoding weather data: \(error)")
                    completion(nil)
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
}
