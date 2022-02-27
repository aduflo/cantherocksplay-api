//
//  Area.swift
//  
//
//  Created by Adam Duflo on 1/16/22.
//

import Vapor

struct Area: Content {
    let id: String
    let name: String
    let coordinate: Coordinate
    let zone: Zone
    
    enum Zone: String, CaseIterable, Content {
        case eastern
        case central
        case mountain
        case pacific
    }
    
    // MARK: Constructor
    
    init(id: String = UUID().uuidString,
         name: String,
         coordinate: Coordinate,
         zone: Zone) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.zone = zone
    }
}

extension Area {
    static func areaToString(_ area: Area) -> String? {
        guard let data = try? JSONEncoder().encode(area) else {
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
        return try JSONDecoder().decode([Area].self, from: data)
    }
}

struct SupportedAreasStorageKey: StorageKey {
    typealias Value = [Area]
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
