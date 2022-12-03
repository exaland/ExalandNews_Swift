//
//  NewsModel.swift
//  newsApi_mvvm
//
//  Created by Alexandre Magnier on 20/11/2022.
//

import Foundation


@objc enum SortBy: Int {
    case Relevancy = 0
    case PublishedAt
    case Popularity
    
    init?(index: Int) {
        switch index {
        case 0: self = .Relevancy
        case 1: self = .PublishedAt
        case 2: self = .Popularity
        default:
            return nil
        }
    }
    
    var title: String? {
        get {
            switch self {
            case .Relevancy: return "Pertinence"
            case .PublishedAt: return "Publié le"
            case .Popularity: return "Popularité"
            }
        }
    }
    var description: String? {
        get {
            switch self {
            case .Relevancy: return "relevancy"
            case .PublishedAt: return "publishedAt"
            case .Popularity: return "popularity"
            }
        }
    }
}

// MARK: - NewsAPI
class NewsAPI: Codable {
    let status: String
    let message: String?
    let totalResults: Int
    let articles: [Article]

    init(status: String, totalResults: Int,message: String?, articles: [Article]) {
        self.status = status
        self.message = message
        self.totalResults = totalResults
        self.articles = articles
    }
}


// MARK: - Article
class Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }

    init(source: Source, author: String?, title: String, articleDescription: String?, url: String, urlToImage: String?, publishedAt: Date, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

// MARK: - Source
class Source: Codable {
    let id: String?
    let name: String

    init(id: String?, name: String) {
        self.id = id
        self.name = name
    }
}



// MARK: - NewsError
class NewsError: Codable {
    let status, code, message: String

    init(status: String, code: String, message: String) {
        self.status = status
        self.code = code
        self.message = message
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func newsAPITask(with url: URL, completionHandler: @escaping (NewsAPI?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

