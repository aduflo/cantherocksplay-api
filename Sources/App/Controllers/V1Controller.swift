//
//  V1Controlling.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Fluent
import Vapor
import WCTRPCommon

protocol V1Controlling {
    /// Returns health report.
    static func getHealth(using app: Application) async throws -> V1HealthResponse
}

struct V1Controller: V1Controlling {
    static func getHealth(using app: Application) async throws -> V1HealthResponse {
        // TODO: proper health check
        /*
         to check:
         - db is configured
         - tables exist
         */
        guard app.databases.ids().contains(.psql), try await AreaModel.query(on: app.db).count() == 15 else {
            return .init(message: "The rocks cannot play right now :(")
        }
        
        return .init(message: "The rocks can play :)")
    }
}
