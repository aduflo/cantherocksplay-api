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
    /// Returns area info for associated id.
    static func getAreas(id: String) -> AreasByIdResponse
}

struct AreasController: AreasControlling {
    static func getAreas() -> AreasResponse {
        return AreasResponse(areas: Area.supportedAreas())
    }
    
    static func getAreas(id: String) -> AreasByIdResponse {
        return AreasByIdResponse(id: id)
    }
}
