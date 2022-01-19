//
//  AreasController.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Foundation

struct AreasController {
    
    /// Returns list of supported areas.
    static func getAreas() -> AreasResponse {
        return AreasResponse(areas: Area.supportedAreas())
    }
}
