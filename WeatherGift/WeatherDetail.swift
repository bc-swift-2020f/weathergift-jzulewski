//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by John Zulewski on 10/13/20.
//

import Foundation

private let dateFormatter: DateFormatter = {
    print("Created a date formatter!!")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()


struct DailyWeather {
    var dailyIcon: String
    var dailyWeekday: String
    var dailySummary: String
    var dailyHigh: Int
    var dailyLow: Int
}

class WeatherDetail: WeatherLocation {
    
    private struct Result: Codable {
        var timezone: String
        var current: Current
        var daily: [Daily]
    }
    
    private struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    private struct Weather: Codable {
        var description: String
        var icon: String
    }
    
    private struct Daily: Codable {
        var dt: TimeInterval
        var temp: Temp
        var weather: [Weather]
    }
    
    private struct Temp: Codable {
        var max: Double
        var min: Double
    }
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dayIcon = ""
    var dailyWeatherData: [DailyWeather] = []
    
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
                self.dayIcon = self.fileNameForIcon(icon: result.current.weather[0].icon)
                for index in 0..<result.daily.count {
                    let weekdayDate = Date(timeIntervalSince1970: result.daily[index].dt)
                    dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let dailyWeekday = dateFormatter.string(from: weekdayDate)
                    let dailyIcon = self.fileNameForIcon(icon: result.daily[index].weather[0].icon)
                    let dailySummary = result.daily[index].weather[0].description
                    let dailyHigh = Int(result.daily[index].temp.max.rounded())
                    let dailyLow = Int(result.daily[index].temp.min.rounded())
                    let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: dailyWeekday, dailySummary: dailySummary, dailyHigh: dailyHigh, dailyLow: dailyLow)
                    self.dailyWeatherData.append(dailyWeather)
                    print("Day: \(dailyWeekday), High: \(dailyHigh), Low: \(dailyLow)")
                }
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
