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
    
    var locationIDs = UserDefaults.standard.array(forKey: "locations") as? [String]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageControl = UIPageControl()

        addChild(pageController)
        view.addSubview(pageController.view)
        pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        
        configureVCs()
        pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
        
    }
    
    func configureVCs() {
        if (locationIDs == nil || locationIDs?.count == 0) {
            locationIDs?.append(GMSPlaces.shared.getCurrentLocationID())
            UserDefaults.standard.set(locationIDs, forKey: "locations")
        }
        
        for id in locationIDs! {
            let loc: CLLocation = GMSPlaces.shared.getLocation(id: id)
            WeatherRequest.shared.weather(at: loc) {[weak self] result in
                switch result {
                case .success(let weather):
                    let vc: WeatherPageVC = WeatherPageVC()
                    vc.weather = weather
                    vc.loc = loc
                    self?.controllers.append(vc)
                case .failure:
                    print("Error with a weather request at location \(loc.description)")
                    return
                }
            }
        }
    }
    
}

extension MainVC: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController as! WeatherPageVC) {
            if index > 0 {
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
        <#code#>
    }

}
