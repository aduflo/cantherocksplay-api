//
//  DataController.swift
//  
//
//  Created by Adam Duflo on 1/24/22.
//

import Fluent
import Vapor
import WCTRPCommon

protocol DataControlling {
    ///
    static func getRefresh(using request: Request) async throws -> DataRefreshResponse
    ///
    static func getRefresh(zone: Zone, using request: Request) async throws -> DataRefreshByZoneResponse
}

struct DataController: DataControlling {
    static func getRefresh(using request: Request) async throws -> DataRefreshResponse {
        let areas = try Self.extractAreas(using: request.application)
        try await DataRefreshService.refreshWeatherData(for: areas, using: request.client, request.db)
        return .init()
    }
    
    static func getRefresh(zone: Zone, using request: Request) async throws -> DataRefreshByZoneResponse {
        let areas = try Self.extractAreas(using: request.application)
        let zoneMatchedAreas = areas.filter { $0.zone == zone }
        try await DataRefreshService.refreshWeatherData(for: zoneMatchedAreas, using: request.client, request.db)
        return .init()
    }
}

extension DataController {
    static func extractAreas(using app: Application) throws -> Areas {
        return [] as Areas
        // TODO: lots of work
//        guard let supportedAreas = app.supportedAreas else {
//            throw Abort(.internalServerError, reason: "Failed to extract supportedAreas")
//        }
//
//        return supportedAreas
    }
}
