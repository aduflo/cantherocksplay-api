//
//  AreasResponse.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Vapor

struct AreasResponse: Content {
    let areas: [String]
}

extension AreasResponse {
    static func supported() -> Self {
        return AreasResponse(areas: [
            "The Gunks",
            "Red River Gorge",
            "Red Rock Canyon",
        ])
    }
}
