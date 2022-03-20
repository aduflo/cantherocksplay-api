//
//  V1Controlling.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Fluent
import Vapor
import WCTRPCommon

protocol V1Controlling {
    /// Returns health report.
    static func getHealth(using app: Application) async throws -> V1HealthResponse
}

struct V1Controller: V1Controlling {
    static func getHealth(using app: Application) async throws -> V1HealthResponse {
        guard let areaCount = try? await AreaModel.query(on: app.db).count(),
              areaCount == 15,
              let todaysForecastCount = try? await TodaysForecastModel.query(on: app.db).count(),
              todaysForecastCount == 15,
              let weatherHistoryCount = try? await WeatherHistoryModel.query(on: app.db).count(),
              weatherHistoryCount == 15
        else {
            return .init(message: "The rocks are resting :(")
        }
        
        return .init(message: "The rocks can play :)")
    }
}
