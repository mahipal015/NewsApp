//
//  ArticleResult.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 27/1/2023.
//

import Foundation

struct ArticleResult: Codable, Equatable {
    let totalResults: Int?
    let articles: [ArticleModel]?
}

