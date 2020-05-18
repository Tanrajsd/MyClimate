//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        // have to update the plist to shwo the right message when requesting
        locationManager.requestWhenInUseAuthorization()
        // this one is for a one time usage
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
}


//MARK: - UITextFieldDelegate


extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
           searchTextField.endEditing(true)
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           searchTextField.endEditing(true)
           return true
       }
       
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           if searchTextField.text != "" {
               return true
           } else {
               searchTextField.placeholder = "Type a city please"
               return false
           }
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           
           if let city = searchTextField.text {
               weatherManager.fetchWeather(cityName: city)
           }
           
           searchTextField.text = ""
       }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
       func didUpdateWeather(weather: WeatherModel) {
           DispatchQueue.main.async {
               self.temperatureLabel.text = weather.tempString
               self.cityLabel.text = weather.cityName
               self.conditionImageView.image = UIImage(systemName: weather.conditionName)
           }
       }
    
        func didFailWithError(error: Error) {
            print(error)
        }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager , didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitutde: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

