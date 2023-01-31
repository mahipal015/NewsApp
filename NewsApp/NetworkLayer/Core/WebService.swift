//
//  WebService.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 23/1/2023.
//

import RxSwift

protocol WebServiceProtocol {
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T>
}

final class WebService: WebServiceProtocol {
    func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return URLRequest.load(resource: resource)
    }
}

