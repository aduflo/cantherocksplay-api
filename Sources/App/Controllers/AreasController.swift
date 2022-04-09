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

fileprivate extension AreasController {
    static func getTodaysWeather(using dailyForecast: AWForecasts1DayDataResponse.DailyForecast) -> AreasByIdResponse.Weather.Today? {
        let weatherType = AreasByIdResponse.Weather.self
        let todayType = weatherType.Today.self
        let temperatureType = todayType.Temperature.self
        let dayUnitType = todayType.DayUnit.self
        let precipitationType = dayUnitType.Precipitation.self
        let temperatureValueUnitType = weatherType.ValueUnit<AreasByIdResponse.Weather.Today.Temperature.Scale>.self
        let amountValueUnitType = weatherType.ValueUnit<AreasByIdResponse.Weather.Today.DayUnit.Precipitation.LengthUnit>.self

        // TODO: check inputs !!!

        let dfTemperature = dailyForecast.temperature
        let awDfDay = dailyForecast.day
        let awDfNight = dailyForecast.night

        guard let dfTemperatureMaximumValue = dfTemperature.maximum?.value,
              let dfTemperatureMaximumUnit = dfTemperature.maximum?.unit,
              let temperatureHighUnit = temperatureType.Scale.init(awScale: dfTemperatureMaximumUnit),
              let dfTemperatureMinimumValue = dfTemperature.minimum?.value,
              let dfTemperatureMinimumUnit = dfTemperature.minimum?.unit,
              let temperatureLowUnit = temperatureType.Scale.init(awScale: dfTemperatureMinimumUnit),
              let awDfDayPrecipitationProbability = awDfDay.precipitationProbability,
              let awDfDayTotalLiquidValue = awDfDay.totalLiquid?.value,
              let awDfDayTotalLiquidUnit = awDfDay.totalLiquid?.unit,
              let daytimePrecipitationAmountUnit = precipitationType.LengthUnit.init(awLengthUnit: awDfDayTotalLiquidUnit),
              let awDfNightPrecipitationProbability = awDfNight.precipitationProbability,
              let awDfNightTotalLiquidValue = awDfNight.totalLiquid?.value,
              let awDfNightTotalLiquidUnit = awDfNight.totalLiquid?.unit,
              let nighttimePrecipitationAmountUnit = precipitationType.LengthUnit.init(awLengthUnit: awDfNightTotalLiquidUnit)
        else {
            return nil
        }

        let temperature = temperatureType.init(
            high: temperatureValueUnitType.init(
                value: dfTemperatureMaximumValue,
                unit: temperatureHighUnit
            ),
            low: temperatureValueUnitType.init(
                value: dfTemperatureMinimumValue,
                unit: temperatureLowUnit
            )
        )


        let daytime = dayUnitType.init(
            message: awDfDay.shortPhrase,
            precipitation: precipitationType.init(
                probability: awDfDayPrecipitationProbability,
                kind: .init(awPrecipitationType: awDfDay.precipitationType),
                intensity: .init(awPrecipitationIntensity: awDfDay.precipitationIntensity),
                amount: amountValueUnitType.init(
                    value: awDfDayTotalLiquidValue,
                    unit: daytimePrecipitationAmountUnit
                )
            )
        )

        let nighttime = dayUnitType.init(
            message: awDfNight.shortPhrase,
            precipitation: precipitationType.init(
                probability: awDfNightPrecipitationProbability,
                kind: .init(awPrecipitationType: awDfNight.precipitationType),
                intensity: .init(awPrecipitationIntensity: awDfNight.precipitationIntensity),
                amount: amountValueUnitType.init(
                    value: awDfNightTotalLiquidValue,
                    unit: nighttimePrecipitationAmountUnit
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
