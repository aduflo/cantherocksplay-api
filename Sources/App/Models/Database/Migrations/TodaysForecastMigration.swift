//
//  TodaysForecastMigration.swift
//  
//
//  Created by Adam Duflo on 3/16/22.
//

import FluentKit

struct TodaysForecastMigration: AsyncMigration {
    fileprivate let schema = TodaysForecastModel.schema
    fileprivate let fieldKeys = TodaysForecastModel.FieldKeys.self
    
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
