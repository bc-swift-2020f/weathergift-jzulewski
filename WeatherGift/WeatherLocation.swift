//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by John Zulewski on 10/13/20.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getData() {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exlcude=minutely&units=imperial&appid=\(APIKeys.openWeatherKey)"
        
        print("You are accessing the url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Could not create URL from \(urlString)")
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
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("\(json)")
            } catch {
                print("JSON Error! \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}


