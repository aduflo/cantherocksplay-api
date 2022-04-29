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
        // TODO: implement :)
        guard let areaModel = try await AreaModel.find(id, on: database) else {
            throw Abort(.notFound)
        }

        let jsonDecoder = JSONDecoder()

        var today: AreasByIdResponse.Weather.Today? = nil
        if let todaysForecast = try? await areaModel.$todaysForecast.get(on: database),
           let decodedResponse = try? jsonDecoder.decode(AWForecasts1DayDataResponse.self, from: todaysForecast.forecast),
           let dailyForecast = decodedResponse.dailyForecasts.first {
            today = .init(dailyForecast: dailyForecast)
        }


        var recentHistory: AreasByIdResponse.Weather.RecentHistory? = nil
        if let dailyHistories = try await areaModel.$weatherHistory.get(on: database)?.dailyHistories {
            for dailyHistory in dailyHistories {
//                let response = try jsonDecoder.decode(AWHistorical24HrDataResponse.self, from: dailyHistory)
//                print("AWHistorical24HrDataResponse: \(response.toJSONString() ?? "")")
//                for hour in response.hours {
//
//                }
            }
        }

        recentHistory = .init() // TODO: cleanup.. only being used to pass guard statement

        guard let today = today,
              let recentHistory = recentHistory
        else {
            throw Abort(.internalServerError, reason: "Insufficient data available to build response")
        }

        return AreasByIdResponse(
            metadata: Area(model: areaModel),
            weather: AreasByIdResponse.Weather(
                today: today,
                recentHistory: recentHistory
            )
        )
    }
}
