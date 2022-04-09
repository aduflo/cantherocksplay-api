//
//  DataRefreshReportMigration.swift
//  
//
//  Created by Adam Duflo on 4/4/22.
//

import FluentKit

extension DataRefreshReportModel {
    struct Migration {
        private static let schema = DataRefreshReportModel.schema
        private static let fieldKeys = DataRefreshReportModel.FieldKeys.self
    }
}

extension DataRefreshReportModel.Migration {
    struct Create: AsyncMigration {
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
}
