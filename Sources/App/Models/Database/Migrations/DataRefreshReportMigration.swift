//
//  DataRefreshReportMigration.swift
//  
//
//  Created by Adam Duflo on 4/4/22.
//

import CTRPCommon
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

extension DataRefreshReportModel.Migration {
    struct AddZoneAsOptionalField: AsyncMigration {
        func prepare(on database: Database) async throws {
            let zoneDataType = try await database.enum(String(describing: fieldKeys.zone)).read()
            try await database
                .schema(schema)
                .field(fieldKeys.zone, zoneDataType)
                .update()
        }

        func revert(on database: Database) async throws {
            try await database
                .schema(schema)
                .deleteField(fieldKeys.zone)
                .update()
        }
    }
}

extension DataRefreshReportModel.Migration {
    struct UpdateZoneAsRequiredField: AsyncMigration {
        func prepare(on database: Database) async throws {
            let zoneDataType = try await database.enum(String(describing: fieldKeys.zone)).read()
            try await database
                .schema(schema)
                .field(fieldKeys.zone, zoneDataType, .required)
                .update()
        }

        func revert(on database: Database) async throws {
            let zoneDataType = try await database.enum(String(describing: fieldKeys.zone)).read()
            try await database
                .schema(schema)
                .field(fieldKeys.zone, zoneDataType)
                .update()
        }
    }
}
