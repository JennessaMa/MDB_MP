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
    
    var locationIDs = UserDefaults.standard.array(forKey: "locations") as? [String]
    
    var controllers : [WeatherPageVC]? {
        didSet {
            guard let controllers = controllers else { return }
            print(controllers)
            pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
        }
    }
    
    var currPlaceID: String? {
        didSet {
            configureVCs()
        }
    }
    
    
    var currVCInd = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageControl = UIPageControl()

        addChild(pageController)
        view.addSubview(pageController.view)
        pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        
        GMSPlaces.shared.setCurrentLocationID(vc: self)
        
    }
        
    func configureVCs() {
        if (locationIDs == nil || locationIDs?.count == 0) {
            locationIDs = []
            locationIDs?.append(currPlaceID!)
        }
        guard let locationIDs = locationIDs else { return }
        print("locationIDs: \(locationIDs) ")
        GMSPlaces.shared.getLocationVCs(locIDs: locationIDs, vc: self)
    }
    
    
}

extension MainVC: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controllers = controllers else { return nil }
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
        guard let controllers = controllers else { return nil }
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
        guard let controllers = controllers else { return }
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = controllers.firstIndex(of: controllers[0]) {
                    self.pageControl.currentPage = viewControllerIndex
                }
            }
    }

}
