//
//  AreasByIdResponse+AW.swift
//  
//
//  Created by Adam Duflo on 4/7/22.
//

import Foundation
import CTRPCommon

extension AreasByIdResponse.Weather.ScaleUnit {
    public init?(awScale: String?) {
        switch awScale {
        case "F":
            self = .fahrenheit
        case "C":
            self = .celsius
        default:
            return nil
        }
    }
}

extension AreasByIdResponse.Weather.Today.DayInfo.Precipitation.Kind {
    public init?(awPrecipitationType: String?) {
        switch awPrecipitationType {
        case "Rain":
            self = .rain
        case "Ice":
            self = .ice
        case "Snow":
            self = .snow
        case "Mixed":
            self = .mixed
        default:
            return nil
        }
    }
}

extension AreasByIdResponse.Weather.Today.DayInfo.Precipitation.Intensity {
    public init?(awPrecipitationIntensity: String?) {
        switch awPrecipitationIntensity {
        case "Light":
            self = .light
        case "Moderate":
            self = .moderate
        case "Heavy":
            self = .heavy
        default:
            return nil
        }
    }
}

extension AreasByIdResponse.Weather.DepthUnit {
    public init?(awLengthUnit: String?) {
        switch awLengthUnit {
        case "in":
            self = .inch
        case "mm":
            self = .millimetre
        default:
            return nil
        }
    }
}
