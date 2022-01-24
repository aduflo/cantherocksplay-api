//
//  AW_LocationGeoSearchResponse.swift
//  
//
//  Created by Adam Duflo on 1/24/22.
//

import Vapor

struct AW_LocationGeoSearchResponse: Content {
    let key: String
}

extension AW_LocationGeoSearchResponse {
    enum CodingKeys: String, CodingKey {
        case key = "Key"
    }
}
