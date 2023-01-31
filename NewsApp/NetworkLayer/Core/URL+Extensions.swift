//
//  URL+Extensions.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 23/1/2023.
//

import Foundation

extension URL {
    static var topHeadlinesUrl: URL? { URL(string: ApiConstant.baseServerURL + ApiConstant.topHeadlines) }
    static var sourcesUrl: URL? { URL(string: ApiConstant.baseServerURL + ApiConstant.getSources) }
}

struct ApiKey {
    static let sources = "sources"
    static let apiKey = "apiKey"
    static let language = "language"
}

struct Environment {
    struct Variables {
        static let appId = "becf5c7800194a9cbff2d47b44951b9e"
        static let sources = "abc-news"
        static let language = "en"
    }
}

struct ApiConstant {
    static let baseServerURL = "https://newsapi.org"
    static let topHeadlines = "/v2/top-headlines"
    static let getSources = "/v2/sources"
}
