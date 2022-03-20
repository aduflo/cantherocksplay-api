//
//  DataRefreshService.swift
//  
//
//  Created by Adam Duflo on 2/25/22.
//

import FluentKit
import Vapor

protocol DataRefreshServicing {
    ///
    func refreshWeatherData(for areaModels: [AreaModel], using database: Database) async throws
    ///
    func refreshWeatherData(for areaModel: AreaModel, using database: Database) async throws
}

// TODO: needs testing... seems to be failing. could be due to api or logic
// TODO: maybe build a collection that holds success / failures (and failure errors unhidden)
struct DataRefreshService {
    let awService: AWServicing
    
    init(client: Client) {
        self.awService = AWService(client: client)
    }
}

extension DataRefreshService: DataRefreshServicing {
    func refreshWeatherData(for areaModels: [AreaModel], using database: Database) async throws {
        for areaModel in areaModels {
            // TODO: determine if optional trying is appropriate. should an entire batch of updates fail for 1 failed area?
            try? await refreshWeatherData(for: areaModel, using: database)
        }
    }
    
    func refreshWeatherData(for areaModel: AreaModel, using database: Database) async throws {
        do {
            try await database.transaction { database in
                let geoData = try await awService.getGeopositionSearchResponse(latitude: areaModel.latitude,
                                                                               longitude: areaModel.longitude)
                try await refreshTodaysForecast(for: areaModel, using: geoData, database)
                try await refreshWeatherHistory(for: areaModel, using: geoData, database)
            }
        } catch {
            let areaId = String(describing: areaModel.id!)
            let reason = "Encountered error while refreshing weather data for areaModel (ID: \(areaId))"
            throw Abort(.internalServerError, reason: reason)
        }
    }
}

extension DataRefreshService {
    func refreshTodaysForecast(for areaModel: AreaModel, using geoData: AWGeopositionSearchDataResponse, _ database: Database) async throws {
        guard let todaysForecast = try await areaModel.$todaysForecast.get(on: database) else {
            throw Abort(.internalServerError, reason: "Failed to get todaysForecast")
        }
        
        let forecasts1DayData = try await awService.getForecasts1DayData(locationKey: geoData.locationKey)
        todaysForecast.forecast = forecasts1DayData
        try await todaysForecast.update(on: database)
    }
    
    func refreshWeatherHistory(for areaModel: AreaModel, using geoData: AWGeopositionSearchDataResponse, _ database: Database) async throws {
        guard let weatherHistory = try await areaModel.$weatherHistory.get(on: database) else {
            throw Abort(.internalServerError, reason: "Failed to get weatherHistory")
        }
        
        let historical24HrData = try await awService.getHistorical24HrData(locationKey: geoData.locationKey)
        weatherHistory.dailyHistories.insert(historical24HrData, at: 0)
        if weatherHistory.dailyHistories.count > 7 {
            weatherHistory.dailyHistories.removeFirst()
        }
        try await weatherHistory.update(on: database)
    }
}
