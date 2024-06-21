//
//  SerieSearchResponse.swift
//  Movies
//
//  Created by lucas vizeu on 30/04/24.
//

import Foundation

struct SerieSearchResponse: Decodable {
    let search: [Serie]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
