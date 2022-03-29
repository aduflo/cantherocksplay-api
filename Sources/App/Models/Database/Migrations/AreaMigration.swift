//
//  AreaMigration.swift
//  
//
//  Created by Adam Duflo on 3/14/22.
//

import FluentKit
import CTRPCommon

struct AreaMigration: AsyncMigration {
    fileprivate let schema = AreaModel.schema
    fileprivate let fieldKeys = AreaModel.FieldKeys.self
    
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
