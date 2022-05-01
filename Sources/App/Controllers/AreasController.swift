//
//  AreasController.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import CTRPCommon
import FluentKit
import Foundation
import Vapor

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
        guard let areaModel = try await AreaModel.find(id, on: database) else {
            throw Abort(.notFound)
        }

        let jsonDecoder = JSONDecoder()

        var awForecasts1DayDataResponse: AWForecasts1DayDataResponse?
        if let todaysForecast = try? await areaModel.$todaysForecast.get(on: database) {
            awForecasts1DayDataResponse = try? jsonDecoder.decode(AWForecasts1DayDataResponse.self, from: todaysForecast.forecast)
        }

        var awHistorical24HrDataResponses: [AWHistorical24HrDataResponse]?
        if let dailyHistories = try? await areaModel.$weatherHistory.get(on: database)?.dailyHistories {
            awHistorical24HrDataResponses = dailyHistories.compactMap { data in
                return try? jsonDecoder.decode(AWHistorical24HrDataResponse.self, from: data)
            }
        }

        guard let awForecasts1DayDataResponse = awForecasts1DayDataResponse,
              let awHistorical24HrDataResponses = awHistorical24HrDataResponses,
              let weather = AreasByIdResponse.Weather(
                awForecasts1DayDataResponse: awForecasts1DayDataResponse,
                awHistorical24HrDataResponses: awHistorical24HrDataResponses
              )
        else {
            throw Abort(.internalServerError, reason: "Failed to build response")
        }

        return AreasByIdResponse(
            metadata: Area(model: areaModel),
            weather: weather
        )
    }
}
