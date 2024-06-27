//
//  SerieSearchResponse.swift
//  Movies
//
//  Created by lucas vizeu on 30/04/24.
//

import Foundation

struct SerieSearchResponse: Decodable {
    let search: [Serie]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

