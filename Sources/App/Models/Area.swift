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
    static func supportedAreas() -> [Self] {
        // constraint: < 25 locations due to AW daily call limit
        return [
            Area(
                name: "Yosemite National Park",
                coordinate: Coordinate(
                    latitude: "37.870322840511534",
                    longitude: "-119.54015724464388"
                ),
                zone: .pacific
            ),
            Area(
                name: "Bishop",
                coordinate: Coordinate(
                    latitude: "37.36165701038517",
                    longitude: "-118.40066648827799"
                ),
                zone: .pacific
            ),
            Area(
                name: "Indian Creek",
                coordinate: Coordinate(
                    latitude: "38.02570696975626",
                    longitude: "-109.53922757138639"
                ),
                zone: .mountain
            ),
            Area(
                name: "Hueco Tanks",
                coordinate: Coordinate(
                    latitude: "31.916516190754773",
                    longitude: "-106.04369166546091"
                ),
                zone: .mountain
            ),
            Area(
                name: "The Shawangunks",
                coordinate: Coordinate(
                    latitude: "41.72558342832264",
                    longitude: "-74.20446298519332"
                ),
                zone: .eastern
            ),
            Area(
                name: "Red River Gorge",
                coordinate: Coordinate(
                    latitude: "37.824437249716546",
                    longitude: "-83.56668016373791"
                ),
                zone: .eastern
            ),
            Area(
                name: "Joshua Tree",
                coordinate: Coordinate(
                    latitude: "33.8837037103912",
                    longitude: "-115.88818209306478"
                ),
                zone: .pacific
            ),
            Area(
                name: "Red Rock",
                coordinate: Coordinate(
                    latitude: "36.19460910534966",
                    longitude: "-115.43825378678054"
                ),
                zone: .pacific
            ),
            Area(
                name: "New River Gorge",
                coordinate: Coordinate(
                    latitude: "37.87743866222177",
                    longitude: "-81.01747485789843"
                ),
                zone: .eastern
            ),
            Area(
                name: "Smith Rock",
                coordinate: Coordinate(
                    latitude: "44.36846062794378",
                    longitude: "-121.14016297728101"
                ),
                zone: .pacific
            ),
            Area(
                name: "Moab",
                coordinate: Coordinate(
                    latitude: "38.57345720018103",
                    longitude: "-109.54970206691677"
                ),
                zone: .mountain
            ),
            Area(
                name: "Rumney",
                coordinate: Coordinate(
                    latitude: "43.80537684026602",
                    longitude: "-71.81215123874279"
                ),
                zone: .eastern
            ),
            Area(
                name: "Horse Pens 40",
                coordinate: Coordinate(
                    latitude: "33.92195338331921",
                    longitude: "-86.30823515377098"
                ),
                zone: .central
            ),
            Area(
                name: "Stone Fort (Little Rock City)",
                coordinate: Coordinate(
                    latitude: "35.248204395457876",
                    longitude: "-85.22003396961017"
                ),
                zone: .eastern
            ),
            Area(
                name: "Rocktown",
                coordinate: Coordinate(
                    latitude: "34.65958069929011",
                    longitude: "-85.38799535185372"
                ),
                zone: .eastern
            ),
        ]
    }
}
