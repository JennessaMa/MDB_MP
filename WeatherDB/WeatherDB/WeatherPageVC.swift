//
//  WeatherPageVC.swift
//  WeatherDB
//
//  Created by Jennessa Ma on 3/24/21.
//

import UIKit
import GooglePlaces

class WeatherPageVC: UIViewController {
    
    var loc: CLLocation? { //unused
        didSet {
            print("set location in weatherpagevc: \(loc!.description)")
        }
    }
    
    var weather: Weather? {
        didSet {
            guard let weather = weather else { return }
            cityName.text = weather.name
            currTemp.text = weather.main.temperature.description + "°"
            currCondition.text = weather.condition.first!.description
            let url: URL = URL(string: "http://openweathermap.org/img/wn/\(weather.condition.first!.icon)@2x.png")!
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self.icon.image = image
                }
            }
            feelsLike.setInfo(info: weather.main.heatIndex.description + "°")
            pressure.setInfo(info: weather.main.pressure.description)
            humidity.setInfo(info: weather.main.humidity.description
            )
        }
    }
    
    var cityName: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 35, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var currTemp: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 50, weight: .medium)
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var icon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var currCondition: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 22, weight: .regular)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var feelsLike: WeatherInfo = {
        let fl = WeatherInfo(title: "Feels Like", info: "")
        fl.translatesAutoresizingMaskIntoConstraints = false
        return fl
    }()
    
    var pressure: WeatherInfo = {
        let p = WeatherInfo(title: "Pressure", info: "")
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    var humidity: WeatherInfo = {
        let h = WeatherInfo(title: "Humidity", info: "")
        h.translatesAutoresizingMaskIntoConstraints = false
        return h
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cityName)
        view.addSubview(icon)
        view.addSubview(currCondition)
        view.addSubview(currTemp)
        
        infoStack.addArrangedSubview(feelsLike)
        infoStack.addArrangedSubview(pressure)
        infoStack.addArrangedSubview(humidity)
        view.addSubview(infoStack)
        
        NSLayoutConstraint.activate([
            cityName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            cityName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 10),
            icon.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            currCondition.topAnchor.constraint(equalTo: icon.topAnchor, constant: 35),
            currCondition.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            currTemp.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20),
            currTemp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoStack.topAnchor.constraint(equalTo: currTemp.bottomAnchor, constant: 35),
            infoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            infoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35)
        ])
        
        view.backgroundColor = .systemGray //change to fit weather condition
        
    }

}
