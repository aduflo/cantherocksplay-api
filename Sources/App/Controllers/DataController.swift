//
//  DataController.swift
//  
//
//  Created by Adam Duflo on 1/24/22.
//

import Vapor

protocol DataControlling {
    ///
    static func getRefresh(using request: Request) async throws -> DataRefreshResponse
    ///
    static func getRefresh(zone: Area.Zone, using request: Request) async throws -> DataRefreshByZoneResponse
    ///
    static func getClear() -> String
    ///
    static func getClear(zone: Area.Zone) -> String
}

struct DataController: DataControlling {
    static func getRefresh(using request: Request) async throws -> DataRefreshResponse {
        guard let supportedAreas = request.application.supportedAreas else {
            throw Abort(.internalServerError, reason: "Failed to extract supportedAreas")
        }
        
        try await DataRefreshService.refreshWeatherData(for: supportedAreas, using: request.client)
        return DataRefreshResponse()
    }
    
    static func getRefresh(zone: Area.Zone, using request: Request) async throws -> DataRefreshByZoneResponse {
        guard let supportedAreas = request.application.supportedAreas else {
            throw Abort(.internalServerError, reason: "Failed to extract supportedAreas")
        }
        
        let zoneMatchedAreas = supportedAreas.filter { $0.zone == zone }
        try await DataRefreshService.refreshWeatherData(for: zoneMatchedAreas, using: request.client)
        return DataRefreshByZoneResponse()
    }
    
    static func getClear() -> String {
        return ""
    }
    
    static func getClear(zone: Area.Zone) -> String {
        return ""
    }
}
