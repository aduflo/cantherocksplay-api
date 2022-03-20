//
//  WeatherHistoryMigration.swift
//  
//
//  Created by Adam Duflo on 3/16/22.
//

import FluentKit

struct WeatherHistoryMigration: AsyncMigration {
    fileprivate let schema = WeatherHistoryModel.schema
    fileprivate let fieldKeys = WeatherHistoryModel.FieldKeys.self
    
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
