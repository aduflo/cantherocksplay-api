//
//  WeatherHistorySeed.swift
//  
//
//  Created by Adam Duflo on 3/16/22.
//

import FluentKit

extension WeatherHistoryModel {
    struct Seed {}
}

extension WeatherHistoryModel.Seed {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            for area in try await AreaModel.query(on: database).all() {
                try await area.$weatherHistory.create(WeatherHistoryModel(dailyHistories: []), on: database)
            }
        }

        func revert(on database: Database) async throws {
            try await WeatherHistoryModel.query(on: database).delete()
        }
    }
}
