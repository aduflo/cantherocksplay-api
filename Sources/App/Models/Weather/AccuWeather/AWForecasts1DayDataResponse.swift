//
//  AWForecasts1DayDataResponse.swift
//  
//
//  Created by Adam Duflo on 1/24/22.
//

import Vapor

struct AWForecasts1DayDataResponse: Content {
    let headline: Headline
    let dailyForecasts: [DailyForecast]
    
    enum CodingKeys: String, CodingKey {
        case headline = "Headline"
        case dailyForecasts = "DailyForecasts"
    }
}

extension AWForecasts1DayDataResponse {
    struct Headline: Content {
        let text: String
        let effectiveDate: String // ISO8601 format
        
        enum CodingKeys: String, CodingKey {
            case text = "Text"
            case effectiveDate = "EffectiveDate"
        }
    }
}

extension AWForecasts1DayDataResponse {
    struct DailyForecast: Content {
        let temperature: Temperature
        let day: DayUnit
        let night: DayUnit
        
        enum CodingKeys: String, CodingKey {
            case temperature = "Temperature"
            case day = "Day"
            case night = "Night"
        }
        
        struct Temperature: Content {
            let minimum: AWValueUnit?
            let maximum: AWValueUnit?
            
            enum CodingKeys: String, CodingKey {
                case minimum = "Minimum"
                case maximum = "Maximum"
            }
        }
        
        struct DayUnit: Content {
            let hasPrecipitation: Bool
            let precipitationType: String? // nil if `precipitationProbability` is 0
            let precipitationIntensity: String? // nil if `precipitationProbability` is 0
            let shortPhrase: String
            let longPhrase: String
            let precipitationProbability: Int?
            let rainProbability: Int?
            let snowProbability: Int?
            let iceProbability: Int?
            let totalLiquid: AWValueUnit?
            let rain: AWValueUnit?
            let snow: AWValueUnit?
            let ice: AWValueUnit?
            
            enum CodingKeys: String, CodingKey {
                case hasPrecipitation = "HasPrecipitation"
                case precipitationType = "PrecipitationType"
                case precipitationIntensity = "PrecipitationIntensity"
                case shortPhrase = "ShortPhrase"
                case longPhrase = "LongPhrase"
                case precipitationProbability = "PrecipitationProbability"
                case rainProbability = "RainProbability"
                case snowProbability = "SnowProbability"
                case iceProbability = "IceProbability"
                case totalLiquid = "TotalLiquid"
                case rain = "Rain"
                case snow = "Snow"
                case ice = "Ice"
            }
        }
    }
}
