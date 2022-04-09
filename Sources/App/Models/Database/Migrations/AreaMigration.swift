//
//  AreaMigration.swift
//  
//
//  Created by Adam Duflo on 3/14/22.
//

import CTRPCommon
import FluentKit

extension AreaModel {
    struct Migration {
        private static let schema = AreaModel.schema
        private static let fieldKeys = AreaModel.FieldKeys.self
    }
}

extension AreaModel.Migration {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            let zoneDataType = try await database.enum(String(describing: fieldKeys.zone)).read()
            try await database
                .schema(schema)
                .id()
                .field(fieldKeys.name, .string, .required)
                .field(fieldKeys.latitude, .string, .required)
                .field(fieldKeys.longitude, .string, .required)
                .field(fieldKeys.zone, zoneDataType, .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(schema).delete()
        }
    }
}
