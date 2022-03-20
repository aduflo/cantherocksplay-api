//
//  TodaysForecastSeed.swift
//  
//
//  Created by Adam Duflo on 3/16/22.
//

import FluentKit
import Foundation

struct TodaysForecastSeed: AsyncMigration {
    func prepare(on database: Database) async throws {
        for area in try await AreaModel.query(on: database).all() {
            try await area.$todaysForecast.create(TodaysForecastModel(forecast: Data()), on: database)
        }
    }
    
    func revert(on database: Database) async throws {
        try await TodaysForecastModel.query(on: database).delete()
    }
}
