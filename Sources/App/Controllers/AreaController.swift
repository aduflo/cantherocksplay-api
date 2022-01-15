//
//  AreaController.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Foundation

struct AreaController {
    
    /// Returns area info for associated id.
    static func getArea(id: String) -> AreaResponse {
        return AreaResponse(id: id)
    }
}
