//
//  AWForecasts1DayDataResponse.swift
//  
//
//  Created by Adam Duflo on 1/24/22.
//

import Vapor

struct AWForecasts1DayDataResponse: Content {
    let headline: Headline
    let dailyForecasts: [DailyForecasts]
    
    enum CodingKeys: String, CodingKey {
        case headline = "Headline"
        case dailyForecasts = "DailyForecasts"
    }
}

extension AWForecasts1DayDataResponse {
    
    struct Headline: Content {
        let text: String
        let effectiveDate: String
        
        enum CodingKeys: String, CodingKey {
            case text = "Text"
            case effectiveDate = "EffectiveDate"
        }
        
        var effectiveDateSansTime: String? {
            guard let firstIdxOfT = effectiveDate.firstIndex(of: "T") else {
                return nil
            }
            
            return String(effectiveDate.prefix(upTo: firstIdxOfT))
        }
    }
}

extension AWForecasts1DayDataResponse {
    
    struct DailyForecasts: Content {
        let temperature: Temperature
        let day: DayUnit
        let night: DayUnit
        
        enum CodingKeys: String, CodingKey {
            case temperature = "Temperature"
            case day = "Day"
            case night = "Night"
        }
        
        struct Temperature: Content {
            let minimum: TempUnit?
            let maximum: TempUnit?
            
            enum CodingKeys: String, CodingKey {
                case minimum = "Minimum"
                case maximum = "Maximum"
            }
            
            struct TempUnit: Content {
                let value: Double?
                let unit: String
                let unitType: Int
                
                enum CodingKeys: String, CodingKey {
                    case value = "Value"
                    case unit = "Unit"
                    case unitType = "UnitType"
                }
            }
        }
        
        struct DayUnit: Content {
            let hasPrecipitation: Bool
            let precipitationType: String?
            let precipitationIntensity: String?
            let shortPhrase: String
            let longPhrase: String
            let precipitationProbability: Int?
            let rainProbability: Int?
            let snowProbability: Int?
            let iceProbability: Int?
            let totalLiquid: PrecipUnit?
            let rain: PrecipUnit?
            let snow: PrecipUnit?
            let ice: PrecipUnit?
            
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
            
            struct PrecipUnit: Content {
                let value: Double?
                let unit: String
                let unitType: Int
                
                enum CodingKeys: String, CodingKey {
                    case value = "Value"
                    case unit = "Unit"
                    case unitType = "UnitType"
                }
            }
        }
    }
}
