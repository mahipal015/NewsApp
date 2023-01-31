//
//  ArticleDTO.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 23/1/2023.
//

import Foundation

struct ArticleDTO: Codable, Equatable {
    let title: String
    let description: String
    let author: String
    let url: String
    let urlToImage: String
    
}

extension ArticleDTO {
    init(_ data: ArticleModel) {
        title = data.title
        description = data.description ?? ""
        author  = data.author ?? ""
        url = data.url ?? ""
        urlToImage = data.urlToImage ?? ""
    }
}
