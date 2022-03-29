//
//  ZoneMigration.swift
//  
//
//  Created by Adam Duflo on 3/14/22.
//

import FluentKit
import CTRPCommon

struct ZoneMigration: AsyncMigration {
    fileprivate let fieldKey = String(describing: Zone.fieldKey)
    
    func prepare(on database: Database) async throws {
        let enumBuilder = database.enum(fieldKey)
        for zoneCase in Zone.allCases {
            _ = enumBuilder.case(zoneCase.rawValue)
        }
        _ = try await enumBuilder.create()
    }
    
    func revert(on database: Database) async throws {
        try await database.enum(fieldKey).delete()
    }
}
