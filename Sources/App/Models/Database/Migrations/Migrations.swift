//
//  Migrations.swift
//  
//
//  Created by Adam Duflo on 3/14/22.
//

import CTRPCommon
import FluentKit

struct Migrations {}

extension Migrations {
    struct Create: AsyncMigration {
        let migrations: [AsyncMigration] = [
            Zone.Migration.Create(),
            AreaModel.Migration.Create(),
            TodaysForecastModel.Migration.Create(),
            WeatherHistoryModel.Migration.Create(),
            DataRefreshReportModel.Migration.Create(),
        ]

        func prepare(on database: Database) async throws {
            for migration in migrations {
                try await migration.prepare(on: database)
            }
        }

        func revert(on database: Database) async throws {
            for migration in migrations.reversed() {
                try await migration.revert(on: database)
            }
        }
    }
}

extension Migrations {
    struct AddUpdatedAtFieldToTodaysForecastAndWeatherHistory: AsyncMigration {
        let migrations: [AsyncMigration] = [
            TodaysForecastModel.Migration.AddUpdatedAt(),
            WeatherHistoryModel.Migration.AddUpdatedAt(),
        ]

        func prepare(on database: Database) async throws {
            for migration in migrations {
                try await migration.prepare(on: database)
            }
        }

        func revert(on database: Database) async throws {
            for migration in migrations.reversed() {
                try await migration.revert(on: database)
            }
        }
    }
}
