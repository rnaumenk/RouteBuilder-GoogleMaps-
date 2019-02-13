//
//  ViewController+GMSMapViewDelegate.swift
//  RouteBuilder(GoogleMaps)
//
//  Created by Ruslan NAUMENKO on 1/27/19.
//  Copyright © 2019 Ruslan NAUMENKO. All rights reserved.
//

import UIKit
import GoogleMaps

extension ViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        googleMaps.selectedMarker = nil
        invalidateTimerChanges()
        
        if isDestinationTapping {
            endMarker.map = nil
            locationSelected = .destinationLocation
            setLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        if isSourceTapping {
            startMarker.map = nil
            locationSelected = .startLocation
            setLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            invalidateTimerChanges()
        }
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.selectedMarker = nil
        invalidateTimerChanges()
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { [unowned self] (timer) in
            self.startLocation.isHidden = true
            self.destinationLocation.isHidden = true
            for button in self.tapButtons {
                button.isHidden = true
            }
            self.segmentedControl.isHidden = true
            if self.isSourceTapping {
                self.isSourceTapping = false
                self.tapButtons[0].setImage(UIImage(named: "off"), for: .normal)
            }
            if self.isDestinationTapping {
                self.isDestinationTapping = false
                self.tapButtons[1].setImage(UIImage(named: "off"), for: .normal)
            }
        })
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
}
