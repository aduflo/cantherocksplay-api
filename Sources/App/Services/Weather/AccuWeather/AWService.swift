//
//  AWService.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Vapor

protocol AWServicing {
    ///
    var host: String { get }
    ///
    var apiKey: String { get }
    
    ///
    func getGeopositionSearchResponse(latitude: String, longitude: String) async throws -> AWGeopositionSearchDataResponse
    ///
    func getForecasts1DayData(locationKey: String) async throws -> Data
    ///
    func getHistorical24HrData(locationKey: String) async throws -> Data
}

struct AWService {
    let client: Client
}

extension AWService: AWServicing {
    var host: String { "dataservice.accuweather.com" }
    var apiKey: String { Environment.get("AW_API_KEY") ?? "" }
    
    func getGeopositionSearchResponse(latitude: String, longitude: String) async throws -> AWGeopositionSearchDataResponse {
        let path = "locations".pathed("v1", "cities", "geoposition", "search")
        let query = "apikey=\(apiKey)&q=\(latitude)%2C\(longitude)"
        let response = try await response(path: path, query: query)
        return try response.content.decode(AWGeopositionSearchDataResponse.self)
    }
    
    func getForecasts1DayData(locationKey: String) async throws -> Data {
        let path = "forecasts".pathed("v1", "daily", "1day", locationKey)
        let query = "apikey=\(apiKey)&details=true"
        let response = try await response(path: path, query: query)
        return try getData(from: response)
    }
    
    func getHistorical24HrData(locationKey: String) async throws -> Data {
        let path = "currentconditions".pathed("v1", locationKey, "historical", "24")
        let query = "apikey=\(apiKey)&details=true"
        let response = try await response(path: path, query: query)
        return try getData(from: response)
    }
}

fileprivate extension AWService {
    func response(path: String, query: String) async throws -> ClientResponse {
        let uri = URI(scheme: .http,
                      host: host,
                      path: path,
                      query: query)
        return try await client.get(uri)
    }
    
    func getData(from clientResponse: ClientResponse) throws -> Data {
        guard let body = clientResponse.body,
              let data = body.getData(at: body.readerIndex, length: body.readableBytes)
        else {
            throw Abort(.internalServerError, reason: "Couldn't get data from clientResponse")
        }
        
        return data
    }
}
