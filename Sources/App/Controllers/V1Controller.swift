//
//  V1Controlling.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Foundation
import WCTRPCommon

protocol V1Controlling {
    /// Returns health report.
    static func getHealth() -> V1HealthResponse
}

struct V1Controller: V1Controlling {
    static func getHealth() -> V1HealthResponse {
        // TODO: proper health check
        /*
         to check:
         - supportedAreas is populated
         - tables exist
         */
        return .init(message: "The rocks can play when they are dry :)")
    }
}
