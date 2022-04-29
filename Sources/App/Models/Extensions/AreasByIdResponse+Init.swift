//
//  AreasByIdResponse+Init.swift
//  
//
//  Created by Adam Duflo on 4/29/22.
//

import CTRPCommon

extension AreasByIdResponse.Weather.Today {
    init?(dailyForecast: AWForecasts1DayDataResponse.DailyForecast) {
        let weatherType = AreasByIdResponse.Weather.self
        let precipitationType = DayUnit.Precipitation.self
        let temperatureValueUnitType = weatherType.ValueUnit<AreasByIdResponse.Weather.Today.Temperature.Scale>.self
        let amountValueUnitType = weatherType.ValueUnit<AreasByIdResponse.Weather.Today.DayUnit.Precipitation.LengthUnit>.self

        let awDfTemperature = dailyForecast.temperature
        let awDfDay = dailyForecast.day
        let awDfNight = dailyForecast.night

        guard let dfTemperatureMaximumValue = awDfTemperature.maximum?.value,
              let dfTemperatureMaximumUnit = awDfTemperature.maximum?.unit,
              let temperatureHighUnit = Temperature.Scale(awScale: dfTemperatureMaximumUnit),
              let dfTemperatureMinimumValue = awDfTemperature.minimum?.value,
              let dfTemperatureMinimumUnit = awDfTemperature.minimum?.unit,
              let temperatureLowUnit = Temperature.Scale(awScale: dfTemperatureMinimumUnit),
              let awDfDayPrecipitationProbability = awDfDay.precipitationProbability,
              let awDfDayTotalLiquidValue = awDfDay.totalLiquid?.value,
              let awDfDayTotalLiquidUnit = awDfDay.totalLiquid?.unit,
              let daytimePrecipitationAmountUnit = precipitationType.LengthUnit(awLengthUnit: awDfDayTotalLiquidUnit),
              let awDfNightPrecipitationProbability = awDfNight.precipitationProbability,
              let awDfNightTotalLiquidValue = awDfNight.totalLiquid?.value,
              let awDfNightTotalLiquidUnit = awDfNight.totalLiquid?.unit,
              let nighttimePrecipitationAmountUnit = precipitationType.LengthUnit(awLengthUnit: awDfNightTotalLiquidUnit)
        else {
            return nil
        }

        let temperature = Temperature(
            high: temperatureValueUnitType.init(
                value: dfTemperatureMaximumValue,
                unit: temperatureHighUnit
            ),
            low: temperatureValueUnitType.init(
                value: dfTemperatureMinimumValue,
                unit: temperatureLowUnit
            )
        )

        let daytime = DayUnit(
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

        let nighttime = DayUnit(
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

        self.init(
            temperature: temperature,
            daytime: daytime,
            nighttime: nighttime
        )
    }
}

extension AreasByIdResponse.Weather.RecentHistory {
//    init() {
//        self.init()
//    }
}
