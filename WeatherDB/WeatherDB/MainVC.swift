//
//  MainVC.swift
//  WeatherDB
//
//  Created by Jennessa Ma on 3/24/21.
//

import UIKit
import GooglePlaces

class MainVC: UIViewController {
    
    static var initialCurrDone = 0 {
        didSet { //set it to new currID?
            
        }
    }

    var pageController: UIPageViewController!
    var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = UIColor.black
        pc.pageIndicatorTintColor = UIColor.lightGray
        pc.currentPage = 0
        return pc
    }()
    
    //locationIDs will start with previously saved locations or []
    //current location added when app launches
    var locationIDs = UserDefaults.standard.array(forKey: "locations") as? [String] ?? []
    var locations: [CLLocation] = [] //unused
    
    var currPlaceID: String? {
        didSet {
            if (MainVC.initialCurrDone == 0) {
                configureVCs()
            } else {
                changeCurrLocVC()
            }
        }
    }
    
    var weathers: [Weather] = [] {
        didSet {
            if (weathers.count == locationIDs.count && starting == 0) {
                createVCs()
            }
        }
    }
    
    var controllers : [WeatherPageVC] = [WeatherPageVC]() {
        didSet {
            if controllers.count == locationIDs.count && starting == 0 {
                pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
                pageController.reloadInputViews()
                starting = 1
                MainVC.initialCurrDone = 1
            }
        }
    }
    
    var addLocation: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 25, weight: .regular))
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.layer.cornerRadius = 41 / 2
        btn.layer.borderWidth = 3
        btn.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        btn.tintColor = .white
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var currVCInd = 0
    
    var starting = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TESTING PURPOSES
//        locationIDs = []
//        UserDefaults.standard.set([], forKey: "locations")
        
        //https://www.hackingwithswift.com/example-code/uikit/how-to-create-a-page-curl-effect-using-uipageviewcontroller
        //https://www.linkedin.com/pulse/using-ios-pageviewcontroller-without-storyboards-paul-tangen/
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        addChild(pageController)
        view.addSubview(pageController.view)
        view.addSubview(pageControl)
        
        let views = ["pageController": pageController.view] as [String: AnyObject]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
        
        view.addSubview(addLocation)
        addLocation.addTarget(self, action: #selector(didTapAddLoc(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            addLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        pageController.dataSource = self
        pageController.delegate = self
        
        GMSPlaces.shared.setCurrentLocationID(vc: self)
        
    }
        
    func configureVCs() {
        //add current location and place at front of pages
        locationIDs.append(currPlaceID!)
        print("index of current place: \(locationIDs.firstIndex(of: currPlaceID!)?.description ?? "")")
        locationIDs.swapAt(0, locationIDs.count - 1)
        pageControl.numberOfPages = locationIDs.count
        GMSPlaces.shared.getLocationVCs(locIDs: locationIDs, vc: self)
    }
    
    func createVCs() {
        for i in 0..<weathers.count {
            print("adding \(weathers[i].name)")
            DispatchQueue.main.async {
                let vc = WeatherPageVC()
                vc.loc = self.locations[i]
                vc.weather = self.weathers[i]
                self.controllers.append(vc)
            }
        }
    }
    
    @objc func didTapAddLoc(_ sender: UIButton) {
        let vc = addLocationVC()
        vc.mainVC = self
        present(vc, animated: true, completion: nil)
    }
    
    func addLocVC(location: CLLocation, placeID: String) {
        let vc = WeatherPageVC()
        vc.loc = location
        WeatherRequest.shared.weather(at: location) { weatherResult in
            switch weatherResult {
            case .success(let weather):
                DispatchQueue.main.async {
                    vc.weather = weather
                }
                self.weathers.append(weather)
            case .failure:
                print("Error with a weather request at added location \(location.description)")
                return
            }
        }
        
        //DEBUGGING STUFF
//        var cities: [String] = []
//        for c in controllers {
//            cities.append(c.cityName.text!)
//        }
//        print("controllers before: \(cities)")
        
        controllers.append(vc)
        locationIDs.append(placeID)
        var temp = locationIDs
        temp.removeFirst() //don't save the current location
        UserDefaults.standard.set(temp, forKey: "locations")
        locations.append(location) //unused
        pageControl.numberOfPages += 1
        //pageController.reloadInputViews()
    }
    
    func changeCurrLocVC() {
        print("in changeCurrLocVC changing current vc")
        DispatchQueue.main.async { [weak self] in
            let newVC = WeatherPageVC()
            newVC.weather = self!.weathers[0]
            newVC.loc = self!.locations[0]
            self!.controllers[0] = newVC
            
            //DEBUGGING STUFF
//            var cities: [String] = []
//            for c in self!.controllers {
//                cities.append(c.cityName.text!)
//            }
//            print("controllers now: \(cities)")
            
            self!.pageController.setViewControllers([self!.controllers[0]], direction: .forward, animated: false)
            self!.pageControl.reloadInputViews()
        }
    }
    
}

extension MainVC: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        if let viewControllerIndex = self.controllers.firstIndex(of: viewController as! WeatherPageVC) {
//                if viewControllerIndex == 0 {
//                    // wrap to last page in array
//                    print("showing last controller")
//                    currVCInd = controllers.count - 1
//                    return self.controllers.last
//                } else {
//                    // go to previous page in array
//                    print("showing index \(viewControllerIndex - 1)")
//                    currVCInd = viewControllerIndex - 1
//                    return self.controllers[viewControllerIndex - 1]
//                }
//            }
        if let index = controllers.firstIndex(of: viewController as! WeatherPageVC) {
                    if index > 0 {
                        currVCInd = index - 1
                        return controllers[index - 1]
                    } else {
                        return nil
                    }
                }
            return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        if let viewControllerIndex = self.controllers.firstIndex(of: viewController as! WeatherPageVC) {
//                if viewControllerIndex < self.controllers.count - 1 {
//                    // go to next page in array
//                    print("showing index \(viewControllerIndex + 1)")
//                    currVCInd = viewControllerIndex + 1
//                    return self.controllers[viewControllerIndex + 1]
//                } else {
//                    // wrap to first page in array
//                    print("showing first controller")
//                    currVCInd = 0
//                    return self.controllers.first
//                }
//            }
    
        if let index = controllers.firstIndex(of: viewController as! WeatherPageVC) {
            if index < controllers.count - 1 {
                currVCInd = index + 1
                return controllers[index + 1]
            } else {
                return nil
            }
        }
            return nil
    }

}

extension MainVC: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let viewControllers = pageViewController.viewControllers {
                if let viewControllerIndex = self.controllers.firstIndex(of: viewControllers[0] as! WeatherPageVC) {
                    self.pageControl.currentPage = viewControllerIndex
                }
            }
        }
    }

}
