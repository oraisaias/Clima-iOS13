//
//  WeatherManager.swift
//  Clima
//
//  Created by Isaías Chávez Martínez on 18/05/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager{
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=ff920b5ceec17588bd1158d289c018b9&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print(urlString)
        performRequest(urlString)
    }
    func performRequest(_ urlString: String){
        //CREATE URL
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    let data = String(data: safeData, encoding: .utf8)!
                    if let weather = parseJSON(safeData){
                        delegate?.didUpdateWeather(self ,weather: weather)
                    }
                }
            }
            task.resume()
            
        }
        
    }
    func parseJSON(_ weatherData: Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode( WeatherData.self, from: weatherData)
            let temp = decoderData.main.temp
            let name = decoderData.name
            let id = decoderData.weather[0].id
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        }catch{
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
   
}
