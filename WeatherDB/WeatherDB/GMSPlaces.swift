//
//  GMSPlaces.swift
//  WeatherDB
//
//  Created by Jennessa Ma on 3/25/21.
//

import Foundation
import GooglePlaces

class GMSPlaces {
        
    static let client = GMSPlacesClient.shared()
    
    static let shared = GMSPlaces()
    
    var currID: String?
    
    var mainRef: MainVC?
    
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
                self.currID = place.placeID //unused
                vc.currPlaceID = place.placeID
                break
              }
            }
        })
    }
    
    
    func getLocation(place: GMSPlace) -> CLLocation {
        return CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
    }
    
    func setLocFromID(placeID: String, addLocVC: addLocationVC) {
        GMSPlaces.client.lookUpPlaceID(placeID, callback: { (result: GMSPlace?, error: Error?) in
            if let error = error {
                print("An error occurred in setLocFromID: \(error.localizedDescription)")
                return
            }
            if let result = result {
                let loc: CLLocation = CLLocation(latitude: result.coordinate.latitude, longitude: result.coordinate.longitude)
                print("setting selected loc: \(loc.description)")
                addLocVC.selectedLoc = loc
            }
        })
    }
    
    func getLocationVCs(locIDs: [String], vc: MainVC) { //fixed ..?
        mainRef = vc
        for id in locIDs {
            GMSPlaces.client.lookUpPlaceID(id, callback: { (result: GMSPlace?, error: Error?) in
                if let error = error {
                    print("An error occurred: \(error.localizedDescription)")
                    return
                }
                if let result = result {
                    let loc: CLLocation = CLLocation(latitude: result.coordinate.latitude, longitude: result.coordinate.longitude)
                    WeatherRequest.shared.weather(at: loc) { weatherResult in
                        switch weatherResult {
                        case .success(let weather):
                            vc.locations.append(loc) //unused
                            vc.weathers.append(weather)
                        case .failure:
                            print("Error with a weather request at location \(loc.description)")
                            return
                        }
                    }
                }
            })
        }
    }
    
    func updateCurrLocation() { 
        print("in UPDATE CURRENT LOCATION")
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
                self.currID = place.placeID //unused
                let loc: CLLocation = LocationManager.shared.location!
                self.mainRef?.locations[0] = loc
                WeatherRequest.shared.weather(at: loc) { weatherResult in
                    switch weatherResult {
                    case .success(let weather):
                        self.mainRef!.currPlaceID = place.placeID
                        self.mainRef?.locations[0] = loc
                        self.mainRef?.weathers[0] = weather
                    case .failure:
                        print("Error with a weather request at location \(loc.description)")
                        return
                    }
                }
                break
              }
            }
        })
    }
}
