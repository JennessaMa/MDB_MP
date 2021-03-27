//
//  GMSPlaces.swift
//  WeatherDB
//
//  Created by Jennessa Ma on 3/25/21.
//

import Foundation
import GooglePlaces

class GMSPlaces {
    
    //static let shared = GooglePlaces.GMSPlacesClient()
    
    static let client = GMSPlacesClient.shared()
    
    static let shared = GMSPlaces()
    
    var currID: String?
    
    var selectedPlace: GMSPlace?
        
    func getCurrentLocation() -> CLLocation {
        var loc: CLLocation?
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue))
        GMSPlaces.client.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
            (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
            if let error = error {
              print("An error occurred: \(error.localizedDescription)")
              return
            }
            if let placeLikelihoodList = placeLikelihoodList {
              for likelihood in placeLikelihoodList {
                let place = likelihood.place
                loc = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                break
              }
            }
        })
        return loc!
    }
    
    func setCurrentLocationID(vc: MainVC) { //fixed
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.placeID.rawValue))

        GMSPlaces.client.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
            (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
            if let error = error {
              print("An error occurred: \(error.localizedDescription)")
              return
            }
            if let placeLikelihoodList = placeLikelihoodList {
              for likelihood in placeLikelihoodList {
                let place = likelihood.place
                self.currID = place.placeID
                vc.currPlaceID = place.placeID
                break
              }
            }
        })
    }
    
    
    func getLocation(place: GMSPlace) -> CLLocation {
        return CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
    }
    
    func getLocationVCs(locIDs: [String], vc: MainVC) {
        for id in locIDs {
            
            GMSPlaces.client.lookUpPlaceID(id, callback: { (result: GMSPlace?, error: Error?) in
                if let error = error {
                    print("An error occurred: \(error.localizedDescription)")
                    return
                }
                if let result = result {
                    let loc: CLLocation = CLLocation(latitude: result.coordinate.latitude, longitude: result.coordinate.longitude)
                    WeatherRequest.shared.weather(at: loc) { result in
                        switch result {
                        case .success(let weather):
                            let weatherVC: WeatherPageVC = WeatherPageVC()
                            weatherVC.weather = weather
                            weatherVC.loc = loc
                            print("appending to vc.controllers")
                            vc.controllers!.append(weatherVC)
                        case .failure:
                            print("Error with a weather request at location \(loc.description)")
                            return
                        }
                    }
                }
            })
        }
    }
}
