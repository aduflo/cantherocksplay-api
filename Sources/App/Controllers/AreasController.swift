//
//  AreasController.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import FluentKit
import Vapor
import WCTRPCommon

protocol AreasControlling {
    /// Returns list of supported areas.
    static func getAreas(using request: Request) async throws -> AreasResponse
    /// Returns area info for associated id.
    static func getAreas(id: String) -> AreasByIdResponse
}

struct AreasController: AreasControlling {
    static func getAreas(using request: Request) async throws -> AreasResponse {
        do {
            let areas = try await AreaModel.query(on: request.db).all().map { model in
                return Area(
                    id: model.id!.uuidString,
                    name: model.name,
                    coordinate: Coordinate(
                        latitude: model.latitude,
                        longitude: model.longitude
                    ),
                    zone: model.zone
                )
            }
            return AreasResponse(areas: areas)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to access database")
        }
    }
    
    static func getAreas(id: String) -> AreasByIdResponse {
        // TODO: implement :)
        return .init(id: id)
    }
}
