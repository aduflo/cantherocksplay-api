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
    static func getAreasById(_ id: UUID, using database: Database) async throws -> AreasByIdResponse
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
    
    static func getAreasById(_ id: UUID, using database: Database) async throws -> AreasByIdResponse {
        guard let areaModel = try await AreaModel.find(id, on: database) else {
            throw Abort(.notFound)
        }

        guard let weatherData = await Self.getAreasById_weatherData(areaModel: areaModel, using: database) else {
            throw Abort(.internalServerError, reason: "Failed to build response")
        }

        let canTheRocksPlay = Self.getAreasById_canTheRocksPlay(using: weatherData)

        return AreasByIdResponse(
            metadata: Area(model: areaModel),
            canTheRocksPlay: canTheRocksPlay,
            weatherData: weatherData
        )
    }
}

extension AreasController {
    private static func getAreasById_weatherData(areaModel: AreaModel, using database: Database) async -> AreasByIdResponse.WeatherData? {
        let jsonDecoder = JSONDecoder()

        // derive awForecasts1DayDataResponse
        var awForecasts1DayDataResponse: AWForecasts1DayDataResponse?
        if let todaysForecast = try? await areaModel.$todaysForecast.get(on: database) {
            awForecasts1DayDataResponse = try? jsonDecoder.decode(AWForecasts1DayDataResponse.self, from: todaysForecast.forecast)
        }

        // derive awHistorical24HrDataResponses
        var awHistorical24HrDataResponses: [AWHistorical24HrDataResponse]?
        if let dailyHistories = try? await areaModel.$weatherHistory.get(on: database)?.dailyHistories {
            awHistorical24HrDataResponses = dailyHistories.compactMap { data in
                return try? jsonDecoder.decode(AWHistorical24HrDataResponse.self, from: data)
            }
        }

        // check responses have values
        guard let awForecasts1DayDataResponse = awForecasts1DayDataResponse,
              let awHistorical24HrDataResponses = awHistorical24HrDataResponses
        else { return nil }

        // construct return value w/ derived content
        return AreasByIdResponse.WeatherData(
            awForecasts1DayDataResponse: awForecasts1DayDataResponse,
            awHistorical24HrDataResponses: awHistorical24HrDataResponses
        )
    }

    private static func getAreasById_canTheRocksPlay(using weatherData: AreasByIdResponse.WeatherData) -> AreasByIdResponse.CanTheRocksPlay {
        // derive directive
        var directive: AreasByIdResponse.CanTheRocksPlay.Directive = .yes

        // check the last 3 entries for precipitation
        for dailyHistory in weatherData.dailyHistories.prefix(3) {
            if dailyHistory.precipitation.amount.metric.value > 0.0 || dailyHistory.precipitation.amount.imperial.value > 0.0 {
                directive = .no
                break
            }
        }

        // check today's forecast for precipitation
        if directive == .yes {
            if weatherData.today.daytime.precipitation.probability > 0 || weatherData.today.nighttime.precipitation.probability > 0 {
                directive = .maybe
            }
        }

        // derive message
        let message: String
        switch directive {
        case .yes:
            message = "The rocks can play!"
        case .no:
            message = "The rocks need some time to dry."
        case .maybe:
            message = "The rocks might bathe today."
        }

        // construct return value w/ derived content
        return AreasByIdResponse.CanTheRocksPlay(
            directive: directive,
            message: message
        )
    }
}
