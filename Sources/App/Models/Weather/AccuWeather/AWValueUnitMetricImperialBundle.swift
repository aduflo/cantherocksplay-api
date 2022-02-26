//
//  AWValueUnitMetricImperialBundle.swift
//  
//
//  Created by Adam Duflo on 2/25/22.
//

import Vapor

struct AWValueUnitMetricImperialBundle: Content {
    let metric: AWValueUnit?
    let imperial: AWValueUnit?
    
    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
        case imperial = "Imperial"
    }
}
