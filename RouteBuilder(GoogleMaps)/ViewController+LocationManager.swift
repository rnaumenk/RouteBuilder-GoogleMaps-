//
//  ViewController+LocationManager.swift
//  RouteBuilder(GoogleMaps)
//
//  Created by Ruslan on 12/26/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import Foundation
import GoogleMaps

extension ViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.myMap?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
}
