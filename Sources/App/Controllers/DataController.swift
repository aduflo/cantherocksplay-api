//
//  DataController.swift
//  
//
//  Created by Adam Duflo on 1/24/22.
//

import Vapor

protocol DataControlling {
    ///
    static func getRefresh(using client: Client) -> String
    ///
    static func getRefresh(zone: Area.Zone, using client: Client) -> String
    ///
    static func getClear() -> String
    ///
    static func getClear(zone: Area.Zone) -> String
}

struct DataController: DataControlling {
    static func getRefresh(using client: Client) -> String {
//        Self.updateWeatherData(for: Area.supportedAreas(), using: client)
        return ""
    }
    
    static func getRefresh(zone: Area.Zone, using client: Client) -> String {
//        let areas = Area.supportedAreas().filter { $0.zone == zone }
//        Self.updateWeatherData(for: areas, using: client)
        return ""
    }
    
    static func getClear() -> String {
        return ""
    }
    
    static func getClear(zone: Area.Zone) -> String {
        return ""
    }
    
//    static func updateWeatherData(for areas: [Area], using client: Client) {
//        let AWService = AWService(client: client)
//        for area in areas {
//            let geoData = try await AWService.getGeopositionSearchData(coordinate: area.coordinate)
//            print("geoData: \(geoData)")
//            let historical24HrData = try await AWService.getHistorical24HrData(locationKey: geoData.locationKey)
//            print("historical24HrData: \(historical24HrData)")
//            let forecasts1DayData = try await AWService.getForecasts1DayData(locationKey: geoData.locationKey)
//            print("forecasts24HrData: \(forecasts1DayData)")
//        }
//    }
}
