//
//  ViewController+ShowPath.swift
//  RouteBuilder(GoogleMaps)
//
//  Created by Ruslan on 12/26/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps

var     oldPolyline:GMSPolyline?
extension ViewController {
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&key=\(apiKey)")!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil { print(error!.localizedDescription)}
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        guard let routes = json["routes"] as? NSArray else { return }
                        if (routes.count > 0) {
                            let overview_polyline = routes[0] as? NSDictionary
                            let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                            let points = dictPolyline?.object(forKey: "points") as? String
                            DispatchQueue.main.async {
                                self.showPath(polyStr: points!)
                            }
                        }
                        else { self.showAlertController("Can't find route")}
                    }
                }
                catch {print("error in JSONSerialization") }
            }
        })
        task.resume()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func showPath(polyStr :String){
        print("yatut")
        if oldPolyline != nil {
            oldPolyline?.map = nil
        }
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        oldPolyline = polyline
        polyline.strokeWidth = 3.0
        polyline.map = myMap // Your map view
    }
}
