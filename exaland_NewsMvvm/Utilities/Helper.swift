//
//  Helper.swift
//  newsApi_mvvm
//
//  Created by Alexandre Magnier on 21/11/2022.
//

import Foundation
import UIKit


class Helper {
    
    func generatePlaceHolder(size: String) -> String {
        
        
        return " https://via.placeholder.com/\(size)"
    }
    
    func generateDatePicker() -> UIDatePicker {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        
        return datePicker
    }
    
    
    func generateAlert(uv: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: "Erreur", message: message , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alertController.addAction(OKAction)
        DispatchQueue.main.async {
            uv.present(alertController,animated: true)

        }
        
    }
}
