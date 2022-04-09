//
//  AreasByIdResponse+AW.swift
//  
//
//  Created by Adam Duflo on 4/7/22.
//

import Foundation
import CTRPCommon

extension AreasByIdResponse.Weather.Today.Temperature.Scale {
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

extension AreasByIdResponse.Weather.Today.DayUnit.Percipitation.Kind {
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

extension AreasByIdResponse.Weather.Today.DayUnit.Percipitation.Intensity {
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

extension AreasByIdResponse.Weather.Today.DayUnit.Percipitation.LengthUnit {
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
