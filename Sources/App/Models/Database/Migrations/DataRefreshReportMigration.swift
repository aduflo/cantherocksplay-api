//
//  DataRefreshReportMigration.swift
//  
//
//  Created by Adam Duflo on 4/4/22.
//

import FluentKit

struct DataRefreshReportMigration: AsyncMigration {
    fileprivate let schema = DataRefreshReportModel.schema
    fileprivate let fieldKeys = DataRefreshReportModel.FieldKeys.self

    func prepare(on database: Database) async throws {
        try await database
            .schema(schema)
            .id()
            .field(fieldKeys.createdAt, .datetime)
            .field(fieldKeys.successes, .array(of: .string), .required)
            .field(fieldKeys.failures, .dictionary(of: .string), .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(schema).delete()
    }
}
