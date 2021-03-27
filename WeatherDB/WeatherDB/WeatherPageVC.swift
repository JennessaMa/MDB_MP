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

    var testLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "testing page"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testLabel)
        testLabel.backgroundColor = UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1)
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }

}
