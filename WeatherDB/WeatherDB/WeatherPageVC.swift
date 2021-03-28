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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }

}
