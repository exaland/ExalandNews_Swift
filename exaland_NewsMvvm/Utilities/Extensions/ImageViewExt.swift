//
//  ImageViewExt.swift
//  newsApi_mvvm
//
//  Created by Alexandre Magnier on 20/11/2022.
//

import Foundation
import UIKit
extension UIImageView {
    
    /**
            Charge une image à partir d'une URL
     */
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
    
    /**
     créé une image circulaire
     */
    func makeRounded() {
           
           layer.borderWidth = 1
           layer.masksToBounds = false
           layer.borderColor = UIColor.black.cgColor
           layer.cornerRadius = self.frame.height / 2
           clipsToBounds = true
       }
}
