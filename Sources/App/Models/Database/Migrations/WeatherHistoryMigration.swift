//
//  WeatherHistoryMigration.swift
//  
//
//  Created by Adam Duflo on 3/16/22.
//

import FluentKit

extension WeatherHistoryModel {
    struct Migration {
        private static let schema = WeatherHistoryModel.schema
        private static let fieldKeys = WeatherHistoryModel.FieldKeys.self
    }
}

extension WeatherHistoryModel.Migration {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(schema)
                .id()
                .field(fieldKeys.dailyHistories, .array(of: .data), .required)
                .field(fieldKeys.area, .uuid, .required, .references(AreaModel.schema, .id))
                .unique(on: fieldKeys.area)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(schema).delete()
        }
    }
}

extension WeatherHistoryModel.Migration {
    struct AddUpdatedAt: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(schema)
                .field(fieldKeys.updatedAt, .datetime)
                .update()
        }

        func revert(on database: Database) async throws {
            try await database
                .schema(schema)
                .deleteField(fieldKeys.updatedAt)
                .update()
        }
    }
}

