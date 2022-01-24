//
//  AccuWeatherService.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Vapor

protocol AccuWeatherServicing {
    
    ///
    static var host: String { get }
    ///
    static var apiKey: String { get }
    
    ///
    static func getGeoData(client: Client, latitude: String, longitude: String) async throws -> AW_LocationGeoSearchResponse
    
    ///
    static func get24HrHistoricData(client: Client, locationKey: String) async throws -> String
    
    ///
    static func get24HrForecast(client: Client, locationKey: String) async throws -> String
}

class AccuWeatherService: AccuWeatherServicing {
    static let host = "dataservice.accuweather.com"
    static let apiKey = Environment.get("AW_API_KEY") ?? ""
}

extension AccuWeatherService {
    
    static func getGeoData(client: Client, latitude: String, longitude: String) async throws -> AW_LocationGeoSearchResponse {
        let uri = Self.getGeoDataURI(latitude: latitude, longitude: longitude)
        let response = try await client.get(uri)
        return try response.content.decode(AW_LocationGeoSearchResponse.self)
    }
    
    static func getGeoDataURI(latitude: String, longitude: String) -> URI {
        return URI(scheme: .http,
                   host: Self.host,
                   path: "locations/v1/cities/geoposition/search",
                   query: "apikey=\(Self.apiKey)&q=\(latitude)%2C\(longitude)")
    }
    
    static func getGeoDataSuccess(response: ClientResponse) {
        print(response)
    }
    
    static func getGeoDataFailure(error: Error) {
        print(error)
    }
}

extension AccuWeatherService {
    
    static func get24HrHistoricData(client: Client, locationKey: String) async throws -> String {
        let uri = get24HrHistoricDataURI(locationKey: locationKey)
        client.get(uri).whenComplete { result in
            switch result {
            case .success(let response):
                Self.get24HrHistoricDataSuccess(response: response)
            case .failure(let error):
                Self.get24HrHistoricDataError(error: error)
            }
        }
        return ""
    }
    
    static func get24HrHistoricDataURI(locationKey: String) -> URI {
        return URI(scheme: .http,
                   host: Self.host,
                   path: "currentconditions/v1/\(locationKey)/historical/24",
                   query: "apikey=\(Self.apiKey)")
    }
    
    static func get24HrHistoricDataSuccess(response: ClientResponse) {
        print(response)
    }
    
    static func get24HrHistoricDataError(error: Error) {
        print(error)
    }
}

extension AccuWeatherService {
    
    static func get24HrForecast(client: Client, locationKey: String) async throws -> String {
        let uri = get24HrForecastURI(locationKey: locationKey)
        client.get(uri).whenComplete { result in
            switch result {
            case .success(let response):
                Self.get24HrForecastSuccess(response: response)
            case .failure(let error):
                Self.get24HrForecastError(error: error)
            }
        }
        return ""
    }
    
    static func get24HrForecastURI(locationKey: String) -> URI {
        return URI(scheme: .http,
                   host: Self.host,
                   path: "forecasts/v1/daily/1day/\(locationKey)",
                   query: "apikey=\(Self.apiKey)")
    }
    
    static func get24HrForecastSuccess(response: ClientResponse) {
        print(response)
    }
    
    static func get24HrForecastError(error: Error) {
        print(error)
    }
}
