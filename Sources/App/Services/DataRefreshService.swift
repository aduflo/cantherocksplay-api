//
//  DataRefreshService.swift
//  
//
//  Created by Adam Duflo on 2/25/22.
//

import Vapor
import WCTRPCommon

struct DataRefreshService {
    static func refreshWeatherData(for areas: Areas, using client: Client) async throws {
        // TODO: fully implement :)
        /* What's this do?
         per iteration:
         - fetch geoData
         - fetch forecasts1DayData + fetch object associated with area.id in respective table
            - once both collected, replace object with latest result
         - fetch historical24HrData + fetch collection associated with area.id in respective table
             - once both collected, add latest result to collection
                 - if collection exceeds 7, trim to 7 (should hold onto 7? why not just 3?)
         */
        
//        for area in areas {
//            Self.refreshWeatherData(for: area, using: AWService(client: client))
//        }
    }
    
//    static func refreshWeatherData(for area: Area, using awService: AWService) async throws {
//        let geoData = try await awService.getGeopositionSearchData(coordinate: area.coordinate)
//        async let forecasts1DayData = awService.getForecasts1DayData(locationKey: geoData.locationKey)
//        async let historical24HrData = awService.getHistorical24HrData(locationKey: geoData.locationKey)
//        _ = try await (forecasts1DayData, historical24HrData)
//    }
}
