//
//  Constants.swift
//  newsApi_mvvm
//
//  Created by Alexandre Magnier on 20/11/2022.
//

import Foundation


struct Constants {
    
    // BASE URL OF NEWSAPI.ORG
    static let BASE_URL = "https://newsapi.org/v2/"
    
    // API KEY NEWSAPI.ORG
    static let API_KEY = "apiKey=eae8932a8e714b649db4131c0bea2303&"
    
    // TOP HEADLINE NEWS FROM NEWSAPI.ORG
    static let TOP_HEADLINES = Constants.BASE_URL + "top-headlines?" + API_KEY
    
    // EVERYTHING ENDPOINT (NEWSAPI.ORG)
    static let EVERYTHING = Constants.BASE_URL + "everything?" + API_KEY
    
    
//https://newsapi.org/v2/top-headlines?country=fr&apiKey=2c06c7754b3d418e86b3097929cc4e23
    
}
