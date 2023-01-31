//
//  SourceListModel.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 23/1/2023.
//

import Foundation

struct SourceListModel: Decodable, Equatable {
    let sources: [SourceModel]?
    let status: String?
}
