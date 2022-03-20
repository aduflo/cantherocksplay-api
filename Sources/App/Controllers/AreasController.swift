//
//  AreasController.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import FluentKit
import Vapor
import WCTRPCommon
import Foundation

protocol AreasControlling {
    /// Returns list of supported areas.
    static func getAreas(using database: Database) async throws -> AreasResponse
    /// Returns area info for associated id.
    static func getAreas(id: UUID, using database: Database) async throws -> AreasByIdResponse
}

struct AreasController: AreasControlling {
    static func getAreas(using database: Database) async throws -> AreasResponse {
        do {
            let areas = try await AreaModel
                .query(on: database)
                .all()
                .map { Area(model: $0) }
            return AreasResponse(areas: areas)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to access database")
        }
    }
    
    static func getAreas(id: UUID, using database: Database) async throws -> AreasByIdResponse {
        // TODO: implement :)
//        guard let areaModel = try await AreaModel.find(id, on: database) else {
//            throw Abort(.notFound)
//        }
//        let history = try await areaModel.$weatherHistory.get(on: database)!
//        
//        let historyResponseObject = try JSONDecoder().decode(AWHistorical24HrDataResponse.self, from: history.dailyHistories[1])
//        let jsonString = historyResponseObject.toJSONString()!
        return .init(id: id, jsonString: "jsonString")
    }
}
