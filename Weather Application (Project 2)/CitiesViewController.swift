//
//  CitiesViewController.swift
//  Weather Application (Project 2)
//
//  Created by Chandani Solanki on 2025-03-29.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
   
    var citiesWeather: [WeatherData] = []
    var isFahrenheit: Bool = false 
    
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
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        let weather = citiesWeather[indexPath.row]
        
        let temp = isFahrenheit ? weather.current.temp_f : weather.current.temp_c
        let unit = isFahrenheit ? "°F" : "°C"
        
        cell.textLabel?.text = "\(weather.location.name): \(temp)\(unit)"
        cell.detailTextLabel?.text = weather.current.condition.text
        
        
        let weatherSymbol = getWeatherSymbol(for: weather.current.condition.code)
        cell.imageView?.image = UIImage(systemName: weatherSymbol)
        cell.imageView?.tintColor = getWeatherColor(for: weather.current.condition.code)
        
        return cell
    }
    
    func getWeatherSymbol(for code: Int) -> String {
        return weatherConditions[code]?.symbol ?? "cloud.fill"
    }
    
    func getWeatherColor(for code: Int) -> UIColor {
        return weatherConditions[code]?.color ?? .lightGray
    }
}
