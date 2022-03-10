//
//  V1Controlling.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import WCTRPCommon
import Vapor

protocol V1Controlling {
    /// Returns health report.
    static func getHealth(app: Application) -> V1HealthResponse
}

struct V1Controller: V1Controlling {
    static func getHealth(app: Application) -> V1HealthResponse {
        // TODO: proper health check
        /*
         to check:
         - db is connected
         - tables exist
         - supportedAreas is populated
         */
        guard app.databases.ids().contains(.psql), app.supportedAreas != nil else {
            return .init(message: "The rocks cannot play right now :(")
        }
        
        return .init(message: "The rocks can play :)")
    }
}
