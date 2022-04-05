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
    static func refreshWeatherData(for zone: Zone, using app: Application) async throws
}

struct DataController: DataControlling {
    static func refreshWeatherData(for zone: Zone, using app: Application) async throws {
        let areas = try await AreaModel
            .query(on: app.db)
            .filter(\.$zone == zone)
            .all()
        return try await DataRefreshService(client: app.client).refreshWeatherData(for: areas, using: app.db)
    }
}
