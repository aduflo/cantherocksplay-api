//
//  TodaysWeatherModel.swift
//  
//
//  Created by Adam Duflo on 3/13/22.
//

import FluentKit

final class TodaysWeatherModel: Model {
    struct Keys {
        static let todaysForecastKey: FieldKey = "todays_forecast"
    }
    
    static let schema = "todays_weathers"
    
    // MARK: Fields
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: Keys.todaysForecastKey)
    var todaysForecast: AWForecasts1DayDataResponse
    
    // MARK: Constructors
    
    init() {}
    
    init(id: UUID? = nil) {
        self.id = id
    }
}

struct TodaysWeatherMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        //
    }
    
    func revert(on database: Database) async throws {
        //
    }
}

struct TodaysWeatherSeed: AsyncMigration {
    func prepare(on database: Database) async throws {
        //
    }
    
    func revert(on database: Database) async throws {
        //
    }
}
