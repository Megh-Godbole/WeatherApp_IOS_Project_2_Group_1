//
//  ViewController.swift
//  Weather Application (Project 2)
//
//
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var conditionLabel: UILabel!
    
    
    let weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var currentWeather: WeatherData?;
    var citiesWeather: [WeatherData] = []

    
    let weatherConditions: [Int: (symbol: String, color: UIColor)] = [
        1000: ("sun.max.fill", .systemYellow),
        1003: ("cloud.sun.fill", .systemBlue),
        1006: ("cloud.fill", .systemGray),
        1009: ("smoke.fill", .systemGray),
        1030: ("cloud.fog.fill", .systemGray),
        1063: ("cloud.drizzle.fill", .systemBlue),
        1066: ("cloud.snow.fill", .systemBlue),
        1087: ("cloud.bolt.fill", .systemOrange),
        1117: ("wind.snow", .systemBlue),
        1135: ("cloud.fog", .systemGray),
        1153: ("cloud.drizzle", .systemBlue),
        1183: ("cloud.rain.fill", .systemBlue),
        1195: ("cloud.heavyrain.fill", .systemBlue),
        1219: ("cloud.snow", .systemTeal),
        1276: ("cloud.bolt.rain.fill", .systemRed),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        // UI Customization
        weatherImageView.tintColor = .gray // Default color
        tempLabel.font = UIFont.boldSystemFont(ofSize: 24)
        cityLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        
    }

    @IBAction func toggleUnit(_ sender: UISwitch) {
        if let weather = currentWeather {
            updateUI(with: weather)
        }
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        // Request location permission
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        guard let city = searchTextField.text, !city.isEmpty else {
            print("Please enter a city name")
            return
        }
        fetchWeather(for: city)
        searchTextField.text = ""
    }

    func fetchWeather(for city: String) {
        weatherManager.fetchWeather(for: city) { [weak self] weather in
            guard let self = self, let weather = weather else { return }
            self.currentWeather = weather
            self.updateUI(with: weather)
            self.citiesWeather.append(weather)
        }
    }
    
    func updateUI(with weather: WeatherData) {
        DispatchQueue.main.async {
            self.cityLabel.text = "\(weather.location.name), \(weather.location.country)"
            let temp = self.toggleSwitch.isOn ? weather.current.temp_f : weather.current.temp_c
            let unit = self.toggleSwitch.isOn ? "F" : "C"
            self.tempLabel.text = "\(temp)° \(unit)"
            self.conditionLabel.text = weather.current.condition.text
        
            
            let weatherSymbol = self.getWeatherSymbol(for: weather.current.condition.code)
            self.weatherImageView.image = UIImage(systemName: weatherSymbol)
            self.weatherImageView.tintColor = self.getWeatherColor(for: weather.current.condition.code)
        }
    }
    
    func getWeatherSymbol(for code: Int) -> String {
        return weatherConditions[code]?.symbol ?? "cloud.fill"
    }

    func getWeatherColor(for code: Int) -> UIColor {
        return weatherConditions[code]?.color ?? .lightGray
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            fetchWeather(for: "\(lat),\(lon)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }
    
    @IBAction func citiesPressed(_ sender: UIButton) {
        if citiesWeather.isEmpty {
            print("No cities added yet")
            return
        }
        performSegue(withIdentifier: "ShowWeatherDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWeatherDetail" {
            if let destinationVC = segue.destination as? CitiesViewController {
                destinationVC.citiesWeather = citiesWeather
                destinationVC.isFahrenheit = toggleSwitch.isOn 
            }
        }
    }

        
    }




