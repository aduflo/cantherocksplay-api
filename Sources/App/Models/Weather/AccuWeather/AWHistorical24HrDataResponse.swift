//
//  AWHistorical24HrDataResponse.swift
//  
//
//  Created by Adam Duflo on 1/24/22.
//

import Vapor

struct AWHistorical24HrDataResponse: Content {
    let hours: [HourData]
    
    init(from decoder: Decoder) throws {
        var hours = [HourData]()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            do {
                hours.append(try container.decode(HourData.self))
            } catch {}
        }
        self.hours = hours
    }
}

extension  AWHistorical24HrDataResponse {
    
    struct HourData: Content {
        let localObservationDateTime: String // ISO8601 format
        let hasPrecipitation: Bool
        let precipitationType: String?
        let temperature: AWValueUnitMetricImperialBundle
        let relativeHumidity: Int?
        let precipitationSummary: PrecipitationSummary
        let temperatureSummary: TemperatureSummary
        
        enum CodingKeys: String, CodingKey {
            case localObservationDateTime = "LocalObservationDateTime"
            case hasPrecipitation = "HasPrecipitation"
            case precipitationType = "PrecipitationType"
            case temperature = "Temperature"
            case relativeHumidity = "RelativeHumidity"
            case precipitationSummary = "PrecipitationSummary"
            case temperatureSummary = "TemperatureSummary"
        }
        
        struct PrecipitationSummary: Content {
            let past24Hours: AWValueUnitMetricImperialBundle
            
            enum CodingKeys: String, CodingKey {
                case past24Hours = "Past24Hours"
            }
        }
        
        struct TemperatureSummary: Content {
            let past24HourRange: PastNHourRange
            
            enum CodingKeys: String, CodingKey {
                case past24HourRange = "Past24HourRange"
            }
            
            struct PastNHourRange: Content {
                let minimum: AWValueUnitMetricImperialBundle
                let maximum: AWValueUnitMetricImperialBundle
                
                enum CodingKeys: String, CodingKey {
                    case minimum = "Minimum"
                    case maximum = "Maximum"
                }
            }
        }
    }
}
