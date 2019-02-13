//
//  ViewController+CLLocationManagerDelegate.swift
//  RouteBuilder(GoogleMaps)
//
//  Created by Ruslan NAUMENKO on 1/27/19.
//  Copyright © 2019 Ruslan NAUMENKO. All rights reserved.
//

import UIKit
import GoogleMaps

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        guard location != nil else {return}
        
        let camera = GMSCameraPosition.camera(withLatitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: 15.0)
        
        googleMaps.animate(to: camera)
        locationManager.stopUpdatingLocation()
    }
}
