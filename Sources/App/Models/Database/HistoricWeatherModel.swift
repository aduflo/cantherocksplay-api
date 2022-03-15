//
//  HistoricWeatherModel.swift
//  
//
//  Created by Adam Duflo on 3/13/22.
//

import FluentKit

final class HistoricWeatherModel: Model {
    struct Keys {
        static let lastSevenDaysWeatherKey: FieldKey = "last_seven_days_weather"
    }
    
    static let schema = "historic_weathers"
    
    // MARK: Fields
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: Key.lastSevenDaysWeatherKey)
    var lastSevenDaysWeather: [AWHistorical24HrDataResponse]
    
    // MARK: Constructors
    
    init() {}
    
    init(id: UUID? = nil) {
        self.id = id
    }
}

struct HistoricWeatherMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        //
    }
    
    func revert(on database: Database) async throws {
        //
    }
}

struct HistoricWeatherSeed: AsyncMigration {
    func prepare(on database: Database) async throws {
        //
    }
    
    func revert(on database: Database) async throws {
        //
    }
}
