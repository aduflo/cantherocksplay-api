//
//  AreaSeed.swift
//  
//
//  Created by Adam Duflo on 3/14/22.
//

import CTRPCommon
import FluentKit

extension AreaModel {
    struct Seed {}
}

extension AreaModel.Seed {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            // constraint: <= 16 areas due to AW daily call limit of 50 (currently calling 3x per area)
            for areaModel in [
                AreaModel(
                    name: "Yosemite National Park",
                    latitude: "37.870322840511534",
                    longitude: "-119.54015724464388",
                    zone: .pacific
                ),
                AreaModel(
                    name: "Bishop",
                    latitude: "37.36165701038517",
                    longitude: "-118.40066648827799",
                    zone: .pacific
                ),
                AreaModel(
                    name: "Indian Creek",
                    latitude: "38.02570696975626",
                    longitude: "-109.53922757138639",
                    zone: .mountain
                ),
                AreaModel(
                    name: "Hueco Tanks",
                    latitude: "31.916516190754773",
                    longitude: "-106.04369166546091",
                    zone: .mountain
                ),
                AreaModel(
                    name: "The Shawangunks",
                    latitude: "41.72558342832264",
                    longitude: "-74.20446298519332",
                    zone: .eastern
                ),
                AreaModel(
                    name: "Red River Gorge",
                    latitude: "37.824437249716546",
                    longitude: "-83.56668016373791",
                    zone: .eastern
                ),
                AreaModel(
                    name: "Joshua Tree",
                    latitude: "33.8837037103912",
                    longitude: "-115.88818209306478",
                    zone: .pacific
                ),
                AreaModel(
                    name: "Red Rock",
                    latitude: "36.19460910534966",
                    longitude: "-115.43825378678054",
                    zone: .pacific
                ),
                AreaModel(
                    name: "New River Gorge",
                    latitude: "37.87743866222177",
                    longitude: "-81.01747485789843",
                    zone: .eastern
                ),
                AreaModel(
                    name: "Smith Rock",
                    latitude: "44.36846062794378",
                    longitude: "-121.14016297728101",
                    zone: .pacific
                ),
                AreaModel(
                    name: "Moab",
                    latitude: "38.57345720018103",
                    longitude: "-109.54970206691677",
                    zone: .mountain
                ),
                AreaModel(
                    name: "Rumney",
                    latitude: "43.80537684026602",
                    longitude: "-71.81215123874279",
                    zone: .eastern
                ),
                AreaModel(
                    name: "Horse Pens 40",
                    latitude: "33.92195338331921",
                    longitude: "-86.30823515377098",
                    zone: .central
                ),
                AreaModel(
                    name: "Stone Fort (Little Rock City)",
                    latitude: "35.248204395457876",
                    longitude: "-85.22003396961017",
                    zone: .eastern
                ),
                AreaModel(
                    name: "Rocktown",
                    latitude: "34.65958069929011",
                    longitude: "-85.38799535185372",
                    zone: .eastern
                ),
                AreaModel(
                    name: "Stoney Point",
                    latitude: "34.27069173711605",
                    longitude: "-118.60373755315237",
                    zone: .pacific
                ),
            ] {
                try await areaModel.create(on: database)
            }
        }

        func revert(on database: Database) async throws {
            try await AreaModel.query(on: database).delete()
        }
    }
}
