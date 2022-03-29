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
    func refreshWeatherData(for areaModels: [AreaModel], using database: Database) async throws -> DataRefreshReport
}

struct DataRefreshService {
    let awService: AWServicing
    
    init(client: Client) {
        self.awService = AWService(client: client)
    }
}

extension DataRefreshService: DataRefreshServicing {
    func refreshWeatherData(for areaModels: [AreaModel], using database: Database) async throws -> DataRefreshReport {
        var successes: [String] = []
        var failures: [String: String] = [:]
        for areaModel in areaModels {
            let areaId = String(describing: areaModel.id!)
            do {
                try await database.transaction { database in
                    let geoData = try await awService.getGeopositionSearchResponse(latitude: areaModel.latitude,
                                                                                   longitude: areaModel.longitude)
                    try await refreshTodaysForecast(for: areaModel, using: geoData, database)
                    try await refreshWeatherHistory(for: areaModel, using: geoData, database)
                }
                successes.append(areaId)
            } catch {
                failures[areaId] = String(describing: error)
            }
        }
        return .init(successes: successes, failures: failures)
    }
}

extension DataRefreshService {
    func refreshTodaysForecast(for areaModel: AreaModel, using geoData: AWGeopositionSearchDataResponse, _ database: Database) async throws {
        guard let todaysForecast = try await areaModel.$todaysForecast.get(on: database) else {
            throw Abort(.internalServerError, reason: "Failed to get todaysForecast from database")
        }
        
        // TODO: determine if wanting 5day forecast instead of 1 day (cause is supported by free api); or is that expanding scope unnecessarily?
        let forecasts1DayData = try await awService.getForecasts1DayData(locationKey: geoData.locationKey)
        todaysForecast.forecast = forecasts1DayData
        try await todaysForecast.update(on: database)
    }
    
    func refreshWeatherHistory(for areaModel: AreaModel, using geoData: AWGeopositionSearchDataResponse, _ database: Database) async throws {
        guard let weatherHistory = try await areaModel.$weatherHistory.get(on: database) else {
            throw Abort(.internalServerError, reason: "Failed to get weatherHistory from database")
        }
        
        let historical24HrData = try await awService.getHistorical24HrData(locationKey: geoData.locationKey)
        weatherHistory.dailyHistories.insert(historical24HrData, at: 0)
        if weatherHistory.dailyHistories.count > 7 {
            weatherHistory.dailyHistories.removeLast()
        }
        try await weatherHistory.update(on: database)
    }
}
