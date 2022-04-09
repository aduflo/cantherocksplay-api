//
//  TodaysForecastMigration.swift
//  
//
//  Created by Adam Duflo on 3/16/22.
//

import FluentKit

extension TodaysForecastModel {
    struct Migration {
        private static let schema = TodaysForecastModel.schema
        private static let fieldKeys = TodaysForecastModel.FieldKeys.self
    }
}

extension TodaysForecastModel.Migration {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database
                .schema(schema)
                .id()
                .field(fieldKeys.forecast, .data, .required)
                .field(fieldKeys.area, .uuid, .required, .references(AreaModel.schema, .id))
                .unique(on: fieldKeys.area)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(schema).delete()
        }
    }
}

extension TodaysForecastModel.Migration {
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
