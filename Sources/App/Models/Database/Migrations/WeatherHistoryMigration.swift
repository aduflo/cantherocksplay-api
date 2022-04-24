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
                .field(fieldKeys.updatedAt, .datetime)
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
