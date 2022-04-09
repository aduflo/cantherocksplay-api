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
            today = getTodaysWeather(using: dailyForecast)
        }


        var recentHistory: AreasByIdResponse.Weather.RecentHistory? = nil
        if let dailyHistories = try await areaModel.$weatherHistory.get(on: database)?.dailyHistories {
            for dailyHistory in dailyHistories {
                let response = try jsonDecoder.decode(AWHistorical24HrDataResponse.self, from: dailyHistory)
                print("AWHistorical24HrDataResponse: \(response.toJSONString() ?? "")")
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

fileprivate extension AreasController {
    static func getTodaysWeather(using dailyForecast: AWForecasts1DayDataResponse.DailyForecast) -> AreasByIdResponse.Weather.Today? {
        let weatherType = AreasByIdResponse.Weather.self
        let todayType = weatherType.Today.self
        let temperatureType = todayType.Temperature.self
        let dayUnitType = todayType.DayUnit.self
        let percipitationType = dayUnitType.Percipitation.self
        let temperatureValueUnitType = weatherType.ValueUnit<AreasByIdResponse.Weather.Today.Temperature.Scale>.self
        let amountValueUnitType = weatherType.ValueUnit<AreasByIdResponse.Weather.Today.DayUnit.Percipitation.LengthUnit>.self

        // TODO: check inputs !!!

        let dfTemperature = dailyForecast.temperature
        let temperature = temperatureType.init(
            high: temperatureValueUnitType.init(
                value: dfTemperature.maximum?.value ?? 0,
                unit: .init(awScale: dfTemperature.maximum?.unit) ?? .fahrenheit
            ),
            low: temperatureValueUnitType.init(
                value: dfTemperature.minimum?.value ?? 0,
                unit: .init(awScale: dfTemperature.minimum?.unit) ?? .fahrenheit
            )
        )


        let awDfDay = dailyForecast.day
        let daytime = dayUnitType.init(
            message: awDfDay.shortPhrase,
            percipitation: percipitationType.init(
                probability: awDfDay.precipitationProbability ?? 0,
                kind: .init(awPrecipitationType: awDfDay.precipitationType),
                intensity: .init(awPrecipitationIntensity: awDfDay.precipitationIntensity),
                amount: amountValueUnitType.init(
                    value: awDfDay.totalLiquid?.value ?? 0,
                    unit: .init(awLengthUnit: awDfDay.totalLiquid?.unit) ?? .inch
                )
            )
        )

        let awDfNight = dailyForecast.night
        let nighttime = dayUnitType.init(
            message: awDfNight.shortPhrase,
            percipitation: percipitationType.init(
                probability: awDfNight.precipitationProbability ?? 0,
                kind: .init(awPrecipitationType: awDfNight.precipitationType),
                intensity: .init(awPrecipitationIntensity: awDfNight.precipitationIntensity),
                amount: amountValueUnitType.init(
                    value: awDfNight.totalLiquid?.value ?? 0,
                    unit: .init(awLengthUnit: awDfNight.totalLiquid?.unit) ?? .inch
                )
            )
        )

        return todayType.init(
            temperature: temperature,
            daytime: daytime,
            nighttime: nighttime
        )
    }

    static func getRecentHistory(using hour: Any) -> AreasByIdResponse.Weather.RecentHistory? {
        return nil
    }
}
