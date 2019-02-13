//
//  ViewController+GMSAutocompleteViewControllerDelegate.swift
//  RouteBuilder(GoogleMaps)
//
//  Created by Ruslan NAUMENKO on 1/27/19.
//  Copyright © 2019 Ruslan NAUMENKO. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        let name = place.name
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        let formattedAddress = place.formattedAddress
        
        setLocation(name: name, latitude: latitude, longitude: longitude, formattedAddress: formattedAddress)
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        googleMaps.camera = camera
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        let location: CLLocation?
        
        switch locationSelected {
        case .startLocation:
            location = locationStart
        case .destinationLocation:
            location = locationEnd
        }
        
        guard location != nil else {return}
        
        let camera = GMSCameraPosition.camera(withLatitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: 15.0)
        googleMaps.camera = camera
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

