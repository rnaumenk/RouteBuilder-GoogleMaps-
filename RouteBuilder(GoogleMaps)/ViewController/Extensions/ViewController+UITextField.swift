//
//  ViewController.swift
//  RouteBuilder(GoogleMaps)
//
//  Created by Ruslan NAUMENKO on 1/27/19.
//  Copyright © 2019 Ruslan NAUMENKO. All rights reserved.
//

import UIKit

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        locationSelected = textField.tag == 0 ? .startLocation : .destinationLocation
        openAutocompleteVC()
    }
}
