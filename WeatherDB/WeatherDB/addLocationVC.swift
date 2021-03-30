//
//  addLocationVC.swift
//  WeatherDB
//
//  Created by Jennessa Ma on 3/29/21.
//

import UIKit
import GooglePlaces

class addLocationVC: UIViewController {
    
    var autocompleteController: GMSAutocompleteViewController = GMSAutocompleteViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        autocompleteController.delegate = self
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
        
    }

}

extension addLocationVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let selectedLoc: CLLocation =  GMSPlaces.shared.getLocation(place: place)
        print("user selected this location: \(String(describing: place.name))")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error in autocomplete: ", error.localizedDescription)
        return
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
