//
//  AWHistorical24HrDataResponse.swift
//  
//
//  Created by Adam Duflo on 1/24/22.
//

import Vapor

struct AWHistorical24HrDataResponse: Content {
    let key: String
}

extension AWHistorical24HrDataResponse {
    enum CodingKeys: String, CodingKey {
        case key = ""
    }
}
