//
//  ViewController.swift
//  RouteBuilder(GoogleMaps)
//
//  Created by Ruslan NAUMENKO on 1/27/19.
//  Copyright © 2019 Ruslan NAUMENKO. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet var googleMaps: GMSMapView!
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var destinationLocation: UITextField!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet var tapButtons: [UIButton]!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var timer: Timer?
    
    let locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    var locationStart: CLLocation?
    var locationEnd: CLLocation?
    
    var startMarker = GMSMarker()
    var endMarker = GMSMarker()
    
    private var polyline = GMSPolyline()
    
    var isSourceTapping = false
    var isDestinationTapping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.layer.cornerRadius = 5
        createRouteButton()
        
        let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 1.0)
        
        googleMaps.camera = camera
        googleMaps.isMyLocationEnabled = true
        googleMaps.settings.myLocationButton = true
        googleMaps.settings.compassButton = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
    }
    
    private func createRouteButton() {
        routeButton.tintColor = UIColor.white
        routeButton.backgroundColor = UIColor.black
        
        routeButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        routeButton.layer.shadowRadius = 1
        routeButton.layer.shadowOpacity = 0.8
        
        routeButton.setImage(UIImage(named: "route"), for: .normal)
        routeButton.layer.cornerRadius = routeButton.frame.width / 2
        routeButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func invalidateTimerChanges() {
        timer?.invalidate()
        
        startLocation.isHidden = false
        destinationLocation.isHidden = false
        for button in tapButtons {
            button.isHidden = false
        }
        segmentedControl.isHidden = false
    }
    
    private func createMarker(titleMarker: String?, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        if let title = titleMarker {
            marker.title = title
            marker.snippet = "\(latitude), \(longitude)"
        }
        else {
            marker.title = "\(latitude), \(longitude)"
        }
        marker.icon = iconMarker
        marker.map = googleMaps
        
        switch locationSelected {
        case .startLocation:
            startMarker = marker
        case .destinationLocation:
            endMarker = marker
        }
    }
    
    private func drawPath(startLocation: CLLocation, endLocation: CLLocation) {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&sensor=true&key=\(APIKey.stringValue)"
        
        polyline.map = nil
        
        Alamofire.request(url).responseJSON { [unowned self] (response) in
            let json = try? JSON(data: response.data!)
            guard json != nil else {
                print("No json")
                return
            }
            
            let routes = json!["routes"].arrayValue
            if let route = routes.first {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                guard points != nil else {
                    print("no points")
                    return
                }
                let path = GMSPath.init(fromEncodedPath: points!)
                self.polyline = GMSPolyline.init(path: path)
                self.polyline.strokeWidth = 4
                self.polyline.strokeColor = .blue
                self.polyline.map = self.googleMaps
            }
            else {
                self.displayAlert("No route")
            }
            
            let camera = GMSCameraPosition.camera(withLatitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude, zoom: 15.0)
            self.googleMaps.animate(to: camera)
        }
    }
    
    func setLocation(name: String? = nil, latitude: CLLocationDegrees, longitude: CLLocationDegrees, formattedAddress: String? = nil) {
        
        let textForField: String!
        if let formatted = formattedAddress {
            textForField = formatted
        }
        else {
            textForField = "\(latitude), \(longitude)"
        }
        
        switch locationSelected {
        case .startLocation:
            startLocation.text = textForField
            locationStart = CLLocation(latitude: latitude, longitude: longitude)
        case .destinationLocation:
            destinationLocation.text = textForField
            locationEnd = CLLocation(latitude: latitude, longitude: longitude)
        }
        
        createMarker(titleMarker: name, iconMarker: UIImage(named: "pin")!, latitude: latitude, longitude: longitude)
    }
    
    func openAutocompleteVC() {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func switchButtons(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if isSourceTapping {
                isSourceTapping = false
                sender.setImage(UIImage(named: "off"), for: .normal)
                startLocation.placeholder = "Enter the source location"
            }
            else {
                isSourceTapping = true
                sender.setImage(UIImage(named: "on"), for: .normal)
                startLocation.placeholder = "Tap on map"
                if isDestinationTapping {
                    tapButtons[1].sendActions(for: .touchUpInside)
                }
            }
        default:
            if isDestinationTapping {
                isDestinationTapping = false
                sender.setImage(UIImage(named: "off"), for: .normal)
                destinationLocation.placeholder = "Enter the destination location"
            }
            else {
                isDestinationTapping = true
                sender.setImage(UIImage(named: "on"), for: .normal)
                destinationLocation.placeholder = "Tap on map"
                if isSourceTapping {
                    tapButtons[0].sendActions(for: .touchUpInside)
                }
            }
        }
    }
    
    @IBAction func buildRoute(_ sender: Any) {
        invalidateTimerChanges()
        if let start = locationStart, let end = locationEnd {
            drawPath(startLocation: start, endLocation: end)
        }
        else {
            displayAlert("Source and destination must be chosen")
        }
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        invalidateTimerChanges()
        switch sender.selectedSegmentIndex {
        case 1:
            UIApplication.shared.statusBarStyle = .lightContent
            do {
                if let styleURL = Bundle.main.url(forResource: "night", withExtension: "json") {
                    googleMaps.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    print("Unable to find night.json")
                }
            } catch {
                print(error)
            }
        default:
            UIApplication.shared.statusBarStyle = .default
            do {
                if let styleURL = Bundle.main.url(forResource: "standard", withExtension: "json") {
                    googleMaps.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    print("Unable to find standard.json")
                }
            } catch {
                print(error)
            }
        }
    }
}
