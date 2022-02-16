//
//  AWGeopositionSearchDataResponse.swift
//  
//
//  Created by Adam Duflo on 1/24/22.
//

import Vapor

struct AWGeopositionSearchDataResponse: Content {
    let locationKey: String
}

extension AWGeopositionSearchDataResponse {
    enum CodingKeys: String, CodingKey {
        case locationKey = "Key"
    }
}
