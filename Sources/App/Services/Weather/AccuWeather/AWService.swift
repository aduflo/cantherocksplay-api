//
//  AWService.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Vapor

protocol AWServicing {
    ///
    static var host: String { get }
    ///
    static var apiKey: String { get }
    
    ///
    var client: Client { get }
    
    ///
    func getGeopositionSearchData(coordinate: Coordinate) async throws -> AWGeopositionSearchDataResponse
    ///
    func getHistorical24HrData(locationKey: String) async throws -> AWHistorical24HrDataResponse
    ///
    func getForecasts1DayData(locationKey: String) async throws -> AWForecasts1DayDataResponse
}

struct AWService: AWServicing {
    static let host = "dataservice.AW.com"
    static let apiKey = Environment.get("AW_API_KEY") ?? ""
    
    let client: Client
}

extension AWService {
    func getGeopositionSearchData(coordinate: Coordinate) async throws -> AWGeopositionSearchDataResponse {
        let uri = getGeopositionSearchDataURI(coordinate: coordinate)
        let response = try await client.get(uri)
        return try response.content.decode(AWGeopositionSearchDataResponse.self)
    }
    
    func getGeopositionSearchDataURI(coordinate: Coordinate) -> URI {
        return URI(scheme: .http,
                   host: Self.host,
                   path: "locations/v1/cities/geoposition/search",
                   query: "apikey=\(Self.apiKey)&q=\(coordinate.latitude)%2C\(coordinate.longitude)")
    }
}

extension AWService {
    func getHistorical24HrData(locationKey: String) async throws -> AWHistorical24HrDataResponse {
        let uri = getHistorical24HrDataURI(locationKey: locationKey)
        let response = try await client.get(uri)
        return try response.content.decode(AWHistorical24HrDataResponse.self)
    }
    
    func getHistorical24HrDataURI(locationKey: String) -> URI {
        // should use detailed flag?
        return URI(scheme: .http,
                   host: Self.host,
                   path: "currentconditions/v1/\(locationKey)/historical/24",
                   query: "apikey=\(Self.apiKey)&details=true")
    }
}

extension AWService {
    func getForecasts1DayData(locationKey: String) async throws -> AWForecasts1DayDataResponse {
        let uri = getForecasts1DayDataURI(locationKey: locationKey)
        let response = try await client.get(uri)
        return try response.content.decode(AWForecasts1DayDataResponse.self)
    }
    
    func getForecasts1DayDataURI(locationKey: String) -> URI {
        // should use detailed flag?
        return URI(scheme: .http,
                   host: Self.host,
                   path: "forecasts/v1/daily/1day/\(locationKey)",
                   query: "apikey=\(Self.apiKey)&details=true")
    }
}
