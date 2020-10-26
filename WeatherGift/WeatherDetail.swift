//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by John Zulewski on 10/13/20.
//

import Foundation

class WeatherDetail: WeatherLocation {
    
    struct Result: Codable {
        var timezone: String
        var current: Current
    }
    
    struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    struct Weather: Codable {
        var description: String
        var icon: String
    }
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
    
    func getData(completed: @escaping () -> ()) {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exlcude=minutely&units=imperial&appid=\(APIKeys.openWeatherKey)"
        
        print("You are accessing the url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Could not create URL from \(urlString)")
            completed()
            return
        }
        
        //Create session
        
        let session = URLSession.shared
        
        //get data from .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
            
            // note: there are additonall things that could go wrong with URLSession but don't worry about it
            
            //deal with the data
            do {
                let result = try JSONDecoder().decode(Result.self, from: data!)
                print("\(result)")
                print("The TimeZone for \(self.name) is: \(result.timezone)")
                self.timezone = result.timezone
                self.currentTime = result.current.dt
                self.temperature = Int(result.current.temp.rounded())
                self.summary = result.current.weather[0].description
                self.dailyIcon = self.fileNameForIcon(icon: result.current.weather[0].icon)
            } catch {
                print("JSON Error! \(error.localizedDescription)")
            }
            completed()
        }
        
        task.resume()
    }
    
    private func fileNameForIcon(icon: String) -> String {
        var newFileName = ""
        switch icon {
        case "01d":
            newFileName = "weather0"
        case "01n":
            newFileName = "weather1"
        case "02d":
            newFileName = "weather2"
        case "02n":
            newFileName = "weather3"
        case "03d", "03n", "04d", "04n":
            newFileName = "weather4"
        case "09d", "09n", "10d", "10n":
            newFileName = "weather5"
        case "11d", "11n":
            newFileName = "weather6"
        case "13d", "13n":
            newFileName = "weather7"
        case "50d", "50n":
            newFileName = "weather8"
        default:
            newFileName = ""
        }
        return newFileName
    }
}
