//
//  WeatherPageVC.swift
//  WeatherDB
//
//  Created by Jennessa Ma on 3/24/21.
//

import UIKit
import GooglePlaces

class WeatherPageVC: UIViewController {
    
    var loc: CLLocation? {
        didSet {
            print("set location: \(loc!.description)")
        }
    }
    
    var weather: Weather? {
        didSet {
            print("set weather: \(weather!.condition)")
            guard let weather = weather else { return }
            cityName.text = weather.name
            currTemp.text = weather.main.temperature.description
            currCondition.text = weather.condition.first!.description
            let url: URL = URL(string: "http://openweathermap.org/img/wn/\(weather.condition.first!.icon)@2x.png")!
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self.icon.image = image
                }
            }
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
        lbl.font = .systemFont(ofSize: 45, weight: .medium)
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
        lbl.font = .systemFont(ofSize: 25, weight: .regular)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(icon)
        view.addSubview(currCondition)
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            icon.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            currCondition.topAnchor.constraint(equalTo: icon.topAnchor, constant: 30),
            currCondition.leadingAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.backgroundColor = .systemPink //change to fit weather condition
        
    }

}
