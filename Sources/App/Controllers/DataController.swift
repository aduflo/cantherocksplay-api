//
//  DataController.swift
//  
//
//  Created by Adam Duflo on 1/24/22.
//

import CTRPCommon
import Fluent
import Vapor

protocol DataControlling {
    ///
    static func getRefresh(using request: Request) async throws -> DataRefreshResponse
    ///
    static func getRefresh(zone: Zone, using request: Request) async throws -> DataRefreshByZoneResponse
}

struct DataController: DataControlling {
    static func getRefresh(using request: Request) async throws -> DataRefreshResponse {
        let areas = try await AreaModel.query(on: request.db).all()
        let report = try await DataRefreshService(client: request.client).refreshWeatherData(for: areas, using: request.db)
        return .init(report: report)
    }
    
    static func getRefresh(zone: Zone, using request: Request) async throws -> DataRefreshByZoneResponse {
        let areas = try await AreaModel
            .query(on: request.db)
            .filter(\.$zone == zone)
            .all()
        let report = try await DataRefreshService(client: request.client).refreshWeatherData(for: areas, using: request.db)
        return .init(report: report)
    }
}
