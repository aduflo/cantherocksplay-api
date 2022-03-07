//
//  Area+Helpers.swift
//  
//
//  Created by Adam Duflo on 1/16/22.
//

import Vapor
import WCTRPCommon

extension Area: Content {}

extension Area {
    /// Convenience initializer leveraging `UUID` for `id` argument.
    static func uuided(name: String, coordinate: Coordinate, zone: Zone) -> Area {
        return Area(id: UUID().uuidString, name: name, coordinate: coordinate, zone: zone)
    }
}

extension Area {
    func toString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}

extension Area {
    static func supportedAreas(using app: Application) throws -> [Self] {
        // constraint: <= 16 areas due to AW daily call limit of 50 (currently calling 3x per area)
        let path = app.directory.resourcesDirectory
        let url = URL(fileURLWithPath: path).appendingPathComponent("supported-areas.json", isDirectory: false)
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(Areas.self, from: data)
    }
}

struct SupportedAreasStorageKey: StorageKey {
    typealias Value = Areas
}

extension Application {
    var supportedAreas: SupportedAreasStorageKey.Value? {
        get {
            self.storage.get(SupportedAreasStorageKey.self)
        }
        set {
            self.storage.set(SupportedAreasStorageKey.self, to: newValue)
        }
    }
}
