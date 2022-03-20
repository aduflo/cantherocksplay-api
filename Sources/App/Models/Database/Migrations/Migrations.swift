//
//  Migrations.swift
//  
//
//  Created by Adam Duflo on 3/14/22.
//

import FluentKit

struct Migrations: AsyncMigration {
    let migrations: [AsyncMigration] = [
        ZoneMigration(),
        AreaMigration(),
        TodaysForecastMigration(),
        WeatherHistoryMigration(),
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
