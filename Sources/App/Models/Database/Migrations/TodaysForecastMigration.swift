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
                .field(fieldKeys.updatedAt, .datetime)
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
