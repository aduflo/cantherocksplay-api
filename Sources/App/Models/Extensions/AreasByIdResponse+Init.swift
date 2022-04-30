//
//  AreasByIdResponse+Init.swift
//  
//
//  Created by Adam Duflo on 4/29/22.
//

import CTRPCommon

extension AreasByIdResponse.Weather {
    init?(awForecasts1DayDataResponse: AWForecasts1DayDataResponse,
          awHistorical24HrDataResponses: [AWHistorical24HrDataResponse]) {
        // create today argument
        guard let dailyForecast = awForecasts1DayDataResponse.dailyForecasts.first else { return nil }

        let temperatureValueUnitType = ValueUnit<ScaleUnit>.self
        let amountValueUnitType = ValueUnit<DepthUnit>.self

        let awDfTemperature = dailyForecast.temperature
        let awDfDay = dailyForecast.day
        let awDfNight = dailyForecast.night

        guard let dfTemperatureMaximumValue = awDfTemperature.maximum?.value,
              let dfTemperatureMaximumUnit = awDfTemperature.maximum?.unit,
              let temperatureHighUnit = ScaleUnit(awScale: dfTemperatureMaximumUnit),
              let dfTemperatureMinimumValue = awDfTemperature.minimum?.value,
              let dfTemperatureMinimumUnit = awDfTemperature.minimum?.unit,
              let temperatureLowUnit = ScaleUnit(awScale: dfTemperatureMinimumUnit),
              let awDfDayPrecipitationProbability = awDfDay.precipitationProbability,
              let awDfDayTotalLiquidValue = awDfDay.totalLiquid?.value,
              let awDfDayTotalLiquidUnit = awDfDay.totalLiquid?.unit,
              let daytimePrecipitationAmountUnit = DepthUnit(awLengthUnit: awDfDayTotalLiquidUnit),
              let awDfNightPrecipitationProbability = awDfNight.precipitationProbability,
              let awDfNightTotalLiquidValue = awDfNight.totalLiquid?.value,
              let awDfNightTotalLiquidUnit = awDfNight.totalLiquid?.unit,
              let nighttimePrecipitationAmountUnit = DepthUnit(awLengthUnit: awDfNightTotalLiquidUnit)
        else {
            return nil
        }

        let temperature = Today.Temperature(
            high: temperatureValueUnitType.init(
                value: dfTemperatureMaximumValue,
                unit: temperatureHighUnit
            ),
            low: temperatureValueUnitType.init(
                value: dfTemperatureMinimumValue,
                unit: temperatureLowUnit
            )
        )

        let daytimeInfo = Today.DayInfo(
            message: awDfDay.shortPhrase,
            precipitation: Today.DayInfo.Precipitation(
                probability: awDfDayPrecipitationProbability,
                kind: .init(awPrecipitationType: awDfDay.precipitationType),
                intensity: .init(awPrecipitationIntensity: awDfDay.precipitationIntensity),
                amount: amountValueUnitType.init(
                    value: awDfDayTotalLiquidValue,
                    unit: daytimePrecipitationAmountUnit
                )
            )
        )

        let nighttimeInfo = Today.DayInfo(
            message: awDfNight.shortPhrase,
            precipitation: Today.DayInfo.Precipitation(
                probability: awDfNightPrecipitationProbability,
                kind: .init(awPrecipitationType: awDfNight.precipitationType),
                intensity: .init(awPrecipitationIntensity: awDfNight.precipitationIntensity),
                amount: amountValueUnitType.init(
                    value: awDfNightTotalLiquidValue,
                    unit: nighttimePrecipitationAmountUnit
                )
            )
        )

        let today = Today(
            temperature: temperature,
            daytimeInfo: daytimeInfo,
            nighttimeInfo: nighttimeInfo
        )

        // create dailyHistories argument
        let dailyHistories: [DailyHistory]
        dailyHistories = awHistorical24HrDataResponses.compactMap { response in
            guard let hour = response.hours.first,
                  let imperialAmountValue = hour.precipitationSummary.past24Hours.imperial?.value,
                  let metricAmountValue = hour.precipitationSummary.past24Hours.metric?.value
            else {
                return nil
            }

            let date = String(hour.localObservationDateTime.prefix(10))

            let imperialAmount = amountValueUnitType.init(
                value: imperialAmountValue,
                unit: .inch
            )
            let metricAmount = amountValueUnitType.init(
                value: metricAmountValue,
                unit: .millimetre
            )
            let precipitation = DailyHistory.Precipitation(
                amount: .init(
                    imperial: imperialAmount,
                    metric: metricAmount
                )
            )

            return DailyHistory(
                date: date,
                precipitation: precipitation
            )
        }

        guard dailyHistories.count == DataRefreshService.maxDailyHistoriesCount else { return nil }

        self.init(
            today: today,
            dailyHistories: dailyHistories
        )
    }
}
