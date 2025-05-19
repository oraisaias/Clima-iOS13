//
//  WeatherManager.swift
//  Clima
//
//  Created by Isaías Chávez Martínez on 18/05/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
struct WeatherManager{
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=ff920b5ceec17588bd1158d289c018b9&units=metric"
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String){
        //CREATE URL
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url ,completionHandler: handle(data:response:error: ) )
            task.resume()
            
        }
        
    }
    func handle(data:Data? ,response: URLResponse?,error: Error?){
        if error != nil{
            print("error")
            return
        }
        if let safeData = data{
            print(String(data: safeData, encoding: .utf8)!)
        }
    }
}
