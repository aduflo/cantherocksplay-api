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
}

struct DataRefreshService {
    let maxCount = 7
    let awService: AWServicing
    
    init(client: Client) {
        self.awService = AWService(client: client)
    }
}

extension DataRefreshService: DataRefreshServicing {
    func refreshWeatherData(for areaModels: [AreaModel], using database: Database) async throws {
        // prepare report data
        var successes: [String] = []
        var failures: [String: String] = [:]

        // refresh areas
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

        // save report
        try await DataRefreshReportModel(successes: successes, failures: failures).save(on: database)

        // trim reports if needed
        try await trimReportsIfNeeded(using: database)
    }
}

extension DataRefreshService {
    fileprivate func refreshTodaysForecast(for areaModel: AreaModel, using geoData: AWGeopositionSearchDataResponse, _ database: Database) async throws {
        guard let todaysForecast = try await areaModel.$todaysForecast.get(on: database) else {
            throw Abort(.internalServerError, reason: "Failed to get todaysForecast from database")
        }

        let forecasts1DayData = try await awService.getForecasts1DayData(locationKey: geoData.locationKey)
        todaysForecast.forecast = forecasts1DayData
        try await todaysForecast.update(on: database)
    }
    
    fileprivate func refreshWeatherHistory(for areaModel: AreaModel, using geoData: AWGeopositionSearchDataResponse, _ database: Database) async throws {
        guard let weatherHistory = try await areaModel.$weatherHistory.get(on: database) else {
            throw Abort(.internalServerError, reason: "Failed to get weatherHistory from database")
        }
        
        let historical24HrData = try await awService.getHistorical24HrData(locationKey: geoData.locationKey)

        var dailyHistories = weatherHistory.dailyHistories
        dailyHistories.insert(historical24HrData, at: 0)
        while dailyHistories.count > maxCount {
            dailyHistories.removeLast()
        }
        weatherHistory.dailyHistories = dailyHistories
        try await weatherHistory.update(on: database)
    }

    fileprivate func trimReportsIfNeeded(using database: Database) async throws {
        let sortedReports = try await DataRefreshReportModel
            .query(on: database)
            .sort(\.$createdAt, .descending)
            .all()

        guard sortedReports.count > maxCount else { return }

        try await database.transaction { database in
            for (i, report) in sortedReports.enumerated() {
                if i < maxCount {
                    continue
                }

                try await report.delete(on: database)
            }
        }
    }
}
