//
//  ViewController.swift
//  RouteBuilder(GoogleMaps)
//
//  Created by Ruslan on 12/26/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController{
    
    @IBOutlet weak var dest: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    enum Location {
        case startLocation
        case destinationLocation
    }
    
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var destinationLocation: UITextField!
    
    var locationSelected = Location.startLocation
    
    var locationStart = CLLocationCoordinate2D()
    var locationEnd = CLLocationCoordinate2D()
    
    @IBOutlet weak var myMap: GMSMapView!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var locationManager = CLLocationManager()
    
    func setUpBtn(){
        searchBtn.toBtn()
        searchBtn.shadowBtn()
        searchBtn.setImage(UIImage(named: "loupe"), for: .normal)
        searchBtn.layer.cornerRadius = self.searchBtn.frame.width / 2
        searchBtn.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        dest.toBtn()
        dest.shadowBtn()
        dest.setImage(UIImage(named: "route"), for: .normal)
        dest.layer.cornerRadius = self.searchBtn.frame.width / 2
        dest.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //show my location
        self.myMap.isMyLocationEnabled = true
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        setUpBtn()
        myMap.delegate = self
        myMap.settings.myLocationButton = true
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func desinationBtnPressed(_ sender: Any) {
        if startLocation.text != "" && destinationLocation.text != "" {
            getPolylineRoute(from: locationStart, to: locationEnd)
            let camera = GMSCameraPosition.camera(withLatitude: locationStart.latitude, longitude: locationStart.longitude, zoom: 15.0)
            self.myMap?.animate(to: camera)
        }
        else {showAlertController("Choose location first") }
    }
    @IBAction func searchBtnPressed(_ sender: Any) {
        myMap.clear()
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension UIButton {
    func toBtn() {
        tintColor = UIColor.white
        backgroundColor = UIColor.black
        
    }
    func shadowBtn() {
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
    }
    
}

extension ViewController {
    
    @IBAction func openStartLocation(_ sender: UIButton) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        locationSelected = .startLocation
        self.locationManager.stopUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    // MARK: when destination location tap, this will open the search location
    @IBAction func openDestinationLocation(_ sender: UIButton) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        locationSelected = .destinationLocation
        self.locationManager.stopUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }
}
