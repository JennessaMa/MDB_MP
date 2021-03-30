//
//  MainVC.swift
//  WeatherDB
//
//  Created by Jennessa Ma on 3/24/21.
//

import UIKit
import GooglePlaces

class MainVC: UIViewController {

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
    
    var didChangeCurrLocation = 0 {
        didSet {
            
        }
    }
    
    var currPlaceID: String? {
        didSet {
            configureVCs()
        }
    }
    
    var weathers: [Weather] = [] {
        didSet {
            if (weathers.count == locationIDs.count) {
                createVCs()
            }
        }
    }
    
    var controllers : [WeatherPageVC] = [WeatherPageVC]() {
        didSet {
            if controllers.count == locationIDs.count {
                print("set viewcontrollers")
                pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
                pageController.reloadInputViews()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        locationIDs.swapAt(0, locationIDs.count - 1)
        print("locationIDs: \(locationIDs) ")
        pageControl.numberOfPages = locationIDs.count
        GMSPlaces.shared.getLocationVCs(locIDs: locationIDs, vc: self)
    }
    
    func createVCs() {
        for i in 0..<weathers.count {
            DispatchQueue.main.async {
                print("adding to controllers list")
                let vc = WeatherPageVC()
                vc.loc = self.locations[i]
                vc.weather = self.weathers[i]
                self.controllers.append(vc)
            }
        }
    }
    
    @objc func didTapAddLoc(_ sender: UIButton) {
        let vc = addLocationVC()
        present(vc, animated: true, completion: nil)
    }
    
    func addLocVC(location: CLLocation) {
        
    }
    
}

extension MainVC: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
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
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = controllers.firstIndex(of: controllers[0]) {
                    self.pageControl.currentPage = viewControllerIndex
                }
            }
    }

}
