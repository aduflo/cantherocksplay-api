//
//  AreasController.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Foundation

protocol AreasControlling {
    /// Returns list of supported areas.
    static func getAreas() -> AreasResponse
}

struct AreasController: AreasControlling {
    static func getAreas() -> AreasResponse {
        return AreasResponse(areas: Area.supportedAreas())
    }
}
