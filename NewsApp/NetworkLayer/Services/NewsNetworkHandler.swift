//
//  NewsNetworkHandler.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 23/1/2023.
//

import Foundation
import RxSwift

protocol NewsListNetworkHandling {
    func getTopHeadlines(_ param: [String: String]?) -> Observable<[ArticleModel]>
}

protocol NewsSourceNetworkHandling {
    func getSources() -> Observable<[SourceModel]>
}

typealias NewsNetworkHandling = NewsListNetworkHandling & NewsSourceNetworkHandling

final class NewsNetworkHandler: NewsNetworkHandling {
    private let defaultParam: [String: String] = [ ApiKey.sources: Environment.Variables.sources, ApiKey.language: Environment.Variables.language ]
    private let webService: WebServiceProtocol

    init(withWebService webService: WebServiceProtocol = WebService()) {
        self.webService = webService
    }

    func getTopHeadlines(_ param: [String: String]?) -> Observable<[ArticleModel]> {
        guard let url = URL.topHeadlinesUrl else { return Observable<[ArticleModel]>.error(NetworkError.badURL) }
        let parameter = param ?? defaultParam
        let resource: Resource<ArticleResult> = { Resource(url: url, parameter: parameter) }()

        return self.webService.load(resource: resource)
            .compactMap { $0.articles ?? [] }
            .retry(2)
    }

    func getSources() -> Observable<[SourceModel]> {
        guard let url = URL.sourcesUrl else { return Observable<[SourceModel]>.error(NetworkError.badURL) }

        let resource: Resource<SourceListModel> = { Resource(url: url) }()

        return self.webService.load(resource: resource)
            .compactMap { $0.sources }
            .retry(2)
    }
}

