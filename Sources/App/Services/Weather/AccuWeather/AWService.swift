//
//  AWService.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Vapor
import WCTRPCommon

protocol AWServicing {
    ///
    static var host: String { get }
    ///
    static var apiKey: String { get }
    
    ///
    var client: Client { get }
    
    ///
    func response(path: String, query: String) async throws -> ClientResponse
    ///
    func getGeopositionSearchData(coordinate: Area.Coordinate) async throws -> AWGeopositionSearchDataResponse
    ///
    func getForecasts1DayData(locationKey: String) async throws -> AWForecasts1DayDataResponse
    ///
    func getHistorical24HrData(locationKey: String) async throws -> AWHistorical24HrDataResponse
}

struct AWService: AWServicing {
    static let host = "dataservice.accuweather.com"
    static let apiKey = Environment.get("AW_API_KEY") ?? ""
    
    let client: Client
}

extension AWService {
    func response(path: String, query: String) async throws -> ClientResponse {
        let uri = URI(scheme: .http,
                      host: Self.host,
                      path: path,
                      query: query)
        return try await client.get(uri)
    }
}

extension AWService {
    func getGeopositionSearchData(coordinate: Area.Coordinate) async throws -> AWGeopositionSearchDataResponse {
        let path = "locations".pathed("v1", "cities", "geoposition", "search")
        let query = "apikey=\(Self.apiKey)&q=\(coordinate.latitude)%2C\(coordinate.longitude)"
        let response = try await response(path: path, query: query)
        return try response.content.decode(AWGeopositionSearchDataResponse.self)
    }
    
    func getForecasts1DayData(locationKey: String) async throws -> AWForecasts1DayDataResponse {
        let path = "forecasts".pathed("v1", "daily", "1day", locationKey)
        let query = "apikey=\(Self.apiKey)&details=true"
        let response = try await response(path: path, query: query)
        return try response.content.decode(AWForecasts1DayDataResponse.self)
    }
    
    func getHistorical24HrData(locationKey: String) async throws -> AWHistorical24HrDataResponse {
        let path = "currentconditions".pathed("v1", locationKey, "historical", "24")
        let query = "apikey=\(Self.apiKey)&details=true"
        let response = try await response(path: path, query: query)
        return try response.content.decode(AWHistorical24HrDataResponse.self)
    }
}
