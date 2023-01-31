//
//  Article.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 17/1/2023.
//

import Foundation

struct ArticleModel : Codable, Equatable {
    
    let source: SourceModel
    
    let title: String
    let url: String?
    let publishedAt: String?
    
    let author: String?
    let description: String?
    let urlToImage: String?
    
    var authorText: String {
        author ?? ""
    }

    var descriptionText: String {
        description ?? ""
    }
    
    var articleURL: URL {
        URL(string: url ?? "")!
    }

    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)

    }
}

extension ArticleModel {
    static func == (lhs: ArticleModel, rhs: ArticleModel) -> Bool {
      return lhs.title == rhs.title && lhs.description == rhs.description
    }
}


struct SourceModel : Codable,Equatable {
    let name: String
    let id: String?
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    let country: String?
    
    var sourceId: String {
        id ?? ""
    }
}

