//
//  AreaModel.swift
//  
//
//  Created by Adam Duflo on 3/13/22.
//

import CTRPCommon
import FluentKit
import Foundation

final class AreaModel: Model {
    static let schema = "areas"
    
    struct FieldKeys {
        static let name: FieldKey = "name"
        static let latitude: FieldKey = "latitude"
        static let longitude: FieldKey = "longitude"
        static let zone: FieldKey = Zone.fieldKey
    }
    
    // MARK: Fields
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: FieldKeys.name)
    var name: String
    
    @Field(key: FieldKeys.latitude)
    var latitude: String
    
    @Field(key: FieldKeys.longitude)
    var longitude: String
    
    @Enum(key: FieldKeys.zone)
    var zone: Zone
    
    @OptionalChild(for: \.$area)
    var todaysForecast: TodaysForecastModel?
    
    @OptionalChild(for: \.$area)
    var weatherHistory: WeatherHistoryModel?
    
    // MARK: Constructors
    
    init() {}
    
    init(name: String,
         latitude: String,
         longitude: String,
         zone: Zone) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.zone = zone
    }
}
