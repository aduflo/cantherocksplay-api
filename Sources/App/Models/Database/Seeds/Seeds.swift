//
//  Seeds.swift
//  cantherocksplay-api
//
//  Created by Adam Duflo on 3/14/22.
//

import FluentKit

struct Seeds {}

extension Seeds {
    struct Create: AsyncMigration {
        let seeds: [AsyncMigration] = [
            AreaModel.Seed.Create(),
            TodaysForecastModel.Seed.Create(),
            WeatherHistoryModel.Seed.Create(),
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
}
