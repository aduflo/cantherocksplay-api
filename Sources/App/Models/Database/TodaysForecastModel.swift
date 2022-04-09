//
//  TodaysForecastModel.swift
//  
//
//  Created by Adam Duflo on 3/13/22.
//

import FluentKit
import Foundation

final class TodaysForecastModel: Model {
    static let schema = "todays_forecasts"
    
    struct FieldKeys {
        static let updatedAt: FieldKey = "updated_at"
        static let forecast: FieldKey = "forecast"
        static let area: FieldKey = "area_id"
    }
    
    // MARK: Fields
    
    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Field(key: FieldKeys.forecast)
    var forecast: Data
    
    @Parent(key: FieldKeys.area)
    var area: AreaModel
    
    // MARK: Constructors
    
    init() {}
    
    init(forecast: Data) {
        self.forecast = forecast
    }
}
