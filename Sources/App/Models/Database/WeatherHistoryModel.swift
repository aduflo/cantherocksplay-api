//
//  WeatherHistoryModel.swift
//  
//
//  Created by Adam Duflo on 3/13/22.
//

import FluentKit
import Foundation

final class WeatherHistoryModel: Model {
    static let schema = "weather_histories"
    
    struct FieldKeys {
        static let updatedAt: FieldKey = "updated_at"
        static let dailyHistories: FieldKey = "daily_histories"
        static let area: FieldKey = "area_id"
    }
    
    // MARK: Fields
    
    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Field(key: FieldKeys.dailyHistories)
    var dailyHistories: [Data]
    
    @Parent(key: FieldKeys.area)
    var area: AreaModel
    
    // MARK: Constructors
    
    init() {}
    
    init(dailyHistories: [Data]) {
        self.dailyHistories = dailyHistories
    }
}
