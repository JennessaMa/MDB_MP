//
//  LocationManager.swift
//  WeatherDB
//
//  Created by Michael Lin on 3/21/21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    // We call this function at didFinishLaunchingWithOptions because
    // static variables are lazily initialized, and we want to minimize
    // the delay of getting the first location.
    static func configure() { let _ = shared }
    
    let manager = CLLocationManager()
    
    var location: CLLocation?
    
    override init() {
        super.init()
        manager.requestWhenInUseAuthorization()
        
        manager.requestAlwaysAuthorization()
        
        manager.delegate = self
        manager.distanceFilter = 1000
        manager.requestLocation()
        manager.startUpdatingLocation()
        
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            return
        }
        manager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (MainVC.initialCurrDone == 1 && location!.coordinate.latitude != locations.first!.coordinate.latitude) {
            print(location!.coordinate.latitude)
            print(locations.first!.coordinate.latitude)
            print("calling updateCurrLocation")
            GMSPlaces.shared.updateCurrLocation()
        }
        location = locations.first
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
              print("Location updates are not authorized: \(error.localizedDescription)")
              manager.stopMonitoringSignificantLocationChanges()
              return
           }
    }
}
