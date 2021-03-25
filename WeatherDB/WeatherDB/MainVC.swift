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
    var pageControl: UIPageControl!
    var controllers = [WeatherPageVC]()
    var locations = UserDefaults.standard.array(forKey: "locations") as? [String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        LocationManager.shared.manager.location
//        GooglePlaces.GMSPlacesClient.init().currentPlace(callback: <#T##GMSPlaceLikelihoodListCallback##GMSPlaceLikelihoodListCallback##(GMSPlaceLikelihoodList?, Error?) -> Void#>)
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageControl = UIPageControl()
        
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
    }
    
}

extension MainVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
}

extension MainVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        <#code#>
    }
    
}
