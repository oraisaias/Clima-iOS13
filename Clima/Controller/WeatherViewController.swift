//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController  {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchTextField: UITextField!
    var weatherManager = WeatherManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    
        // Do any additional setup after loading the view.
    }
   
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
}
//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
     
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type something to search"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
        
        
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel){
        print(weather.temperature)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
       
        
        
    }
    func didFailWithError(error: Error) {
        print("Error: \(error)")
        
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation() // para no seguir pidiendo ubicación
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print( lat, lon)
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Error: \(error.localizedDescription)")
    }
}


