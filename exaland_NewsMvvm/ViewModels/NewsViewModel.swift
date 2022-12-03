//
//  NewsViewModel.swift
//  newsApi_mvvm
//
//  Created by Alexandre Magnier on 20/11/2022.
//

import Foundation


class NewsViewModel {
    
    var newsModelAPI: NewsAPI?
    
    /**
     Obtiens les News en TOP Headline
    - Parameters : country: Pays de l'actualité (ex: fr pour la France)
    - Parameters : category: Categorie de l'actualité (ex: business)

     */
    func fetchNewsTopHeadLine(country: String, category: String,  onSuccess success: @escaping (NewsAPI) -> Void, onFailure failure: @escaping (String) -> Void) {
        
        let countryFinal = country.isEmpty ? country : "fr"
        
        
        let url = URL(string: Constants.TOP_HEADLINES + "country=\(countryFinal)&category=\(category)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { return }
         
            do {
               
                let modelData =
                try? newJSONDecoder().decode(NewsAPI.self, from: unwrappedData)
             
                self.newsModelAPI = modelData
                if modelData?.status == "ok" {
                    
                    success(self.newsModelAPI!)
                } else {
                    let errorData =
                    try? newJSONDecoder().decode(NewsError.self, from: unwrappedData)
                    failure(errorData?.message ?? "")
                }
            } catch {
                print("json error: \(error)")
                failure("\(error)")
            }
        }
        task.resume()
        
        
    }
    
    
    func fetchNewsEverything(query: String,sort: String,from: String,to: String,onSuccess success: @escaping(NewsAPI) -> Void,onFailure failure: @escaping(String) -> Void ) {
        
        
        let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
        
        let fromDates = formatter.string(from: Date.now)
        let fromDate = from.isEmpty ? fromDates : from
        let toDate = to.isEmpty ? fromDates : to
        
        let url = URL(string: Constants.EVERYTHING + "q=\(query.replacingOccurrences(of: " ", with: "%20"))&sortBy=\(sort)&from=\(fromDate)&to=\(toDate)")!
        
        print("query is \(query.replacingOccurrences(of: " ", with: "%20"))")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
               
            
                let modelData =
                try? newJSONDecoder().decode(NewsAPI.self, from: unwrappedData)
             print("data is \(data)")
                self.newsModelAPI = modelData
                if modelData?.status == "ok" {
                    success(self.newsModelAPI!)

                }
            } catch {
                print("json error: \(error)")
                failure("\(error)")
            }
        }
        task.resume()
        
        
    }
    
    
}
