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
    
    static let client = GMSPlacesClient()
    
    static let shared = GMSPlaces()
    
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
    
    func getCurrentLocationID() -> String {
        var id: String?
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
                id = place.placeID
                break
              }
            }
        })
        return id!
    }
    
    func getLocation(place: GMSPlace) -> CLLocation {
        return CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
    }
    
    func getLocation(id: String) -> CLLocation {
        var loc: CLLocation?
        GMSPlaces.client.lookUpPlaceID(id, callback: { (result: GMSPlace?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let result = result {
                loc = CLLocation(latitude: result.coordinate.latitude, longitude: result.coordinate.longitude)
            }
        })
        return loc!
    }
}
