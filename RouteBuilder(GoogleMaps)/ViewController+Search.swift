//
//  ViewController+Search.swift
//  RouteBuilder(GoogleMaps)
//
//  Created by Ruslan on 12/26/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let location = place
        let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 15.0)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: (location.coordinate.longitude))
        marker.title = place.name
        switch  locationSelected {
        case .startLocation:
            locationStart = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            self.startLocation.text = place.formattedAddress
            marker.map = myMap
        case .destinationLocation:
            locationEnd = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            self.destinationLocation.text = place.formattedAddress
            marker.map = myMap
        }
        
        self.myMap?.animate(to: camera)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        let coord = place.coordinate
        let marker = GMSMarker()
        let camera = GMSCameraPosition.camera(withLatitude: coord.latitude, longitude: coord.longitude, zoom: 16.0)
        marker.position = coord
        marker.title = place.name
        marker.map = myMap
        self.myMap.animate(to: camera)
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
