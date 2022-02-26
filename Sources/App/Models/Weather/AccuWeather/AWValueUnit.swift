//
//  AWValueUnit.swift
//  whencantherocksplay-api
//
//  Created by Adam Duflo on 2/25/22.
//

import Vapor

struct AWValueUnit: Content {
    let value: Double?
    let unit: String
    let unitType: Int
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}
