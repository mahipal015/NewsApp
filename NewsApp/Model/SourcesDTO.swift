//
//  SourcesDTO.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 23/1/2023.
//

import Foundation

struct SourcesDTO:Codable, Equatable {
    let id: String
    let name: String
    let description: String
    let url: String?
    let category: String?
}

extension SourcesDTO {
    init(_ data: SourceModel) {
        self.id = data.id ?? ""
        self.name = data.name
        self.description = data.description ?? ""
        self.url = data.url
        self.category = data.category
    }
}
