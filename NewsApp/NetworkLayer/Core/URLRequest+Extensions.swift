//
//  URLRequest+Extensions.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 23/1/2023.
//

import Foundation
import RxCocoa
import RxSwift

struct Resource<T: Decodable> {
    var url: URL
    var parameter: [String: String]?
}

extension URLRequest {
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let url = self.loadURL(resource: resource) ?? url
                
                let request = URLRequest(url: self.loadURL(resource: resource) ?? url)
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in
                
                if 200 ..< 300 ~= response.statusCode {
                    
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        
                        return  result
                    } catch {
                        print(String(describing: error))
                        throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                    }
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
                
            }.asObservable()
    }
    
    static func loadURL<T>(resource: Resource<T>) -> URL? {
        var parameters = resource.parameter ?? [:]
        parameters.updateValue(Environment.Variables.appId, forKey: ApiKey.apiKey) // Add api key
        
        if
            let urlComponents = URLComponents(url: resource.url, resolvingAgainstBaseURL: false) {
            var components = urlComponents
            components.queryItems = parameters.map { (arg) -> URLQueryItem in
                let (key, value) = arg
                return URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            return components.url
        }
        return nil
    }
}
