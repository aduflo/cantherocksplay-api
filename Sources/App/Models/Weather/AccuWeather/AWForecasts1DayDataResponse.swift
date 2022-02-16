//
//  AWForecasts1DayDataResponse.swift
//  
//
//  Created by Adam Duflo on 1/24/22.
//

import Vapor

struct AWForecasts1DayDataResponse : Content {
    let key: String
}

extension AWForecasts1DayDataResponse {
    enum CodingKeys: String, CodingKey {
        case key = ""
    }
}
