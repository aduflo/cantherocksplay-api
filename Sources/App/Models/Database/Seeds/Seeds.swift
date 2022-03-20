//
//  Seeds.swift
//  whencantherocksplay-api
//
//  Created by Adam Duflo on 3/14/22.
//

import FluentKit

struct Seeds: AsyncMigration {
    let seeds: [AsyncMigration] = [
        AreaSeed(),
        TodaysForecastSeed(),
        WeatherHistorySeed(),
    ]
    
    func prepare(on database: Database) async throws {
        for seed in seeds {
            try await seed.prepare(on: database)
        }
    }
    
    func revert(on database: Database) async throws {
        for seed in seeds.reversed() {
            try await seed.revert(on: database)
        }
    }
}
