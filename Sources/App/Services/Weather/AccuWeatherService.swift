//
//  AccuWeatherService.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Vapor

protocol AccuWeatherServicing {
    
    ///
    static var apiKey: String { get }
    
    ///
    var httpService: HTTPService { get }
    
    ///
    typealias GetGeoDataHandler = (Result<String, Error>) -> Void
    ///
    func getGeoData(latitude: String, longitude: String, completion: @escaping GetGeoDataHandler)
    
    ///
    typealias Get24HrHistoricDataHandler = (Result<String, Error>) -> Void
    ///
    func get24HrHistoricData()
    
    ///
    typealias Get24HrForecastHandler = (Result<String, Error>) -> Void
    ///
    func get24HrForecast()
}

class AccuWeatherService: AccuWeatherServicing {
    
    static let apiKey = Environment.get("AW_API_KEY") ?? ""
    
    let httpService = HTTPService()
    
    // MARK: getGeoData functions
    
    func getGeoData(latitude: String, longitude: String, completion: @escaping GetGeoDataHandler) {
        let request = getGeoDataHTTPRequest(latitude: latitude, longitude: longitude)
        httpService.get(request) { [weak self] result in
            switch result {
            case .success(let data):
                self?.getGeoDataSuccess(data: data, completion: completion)
            case .failure(let error):
                self?.getGeoDataFailure(error: error, completion: completion)
            }
        }
    }
    
    func getGeoDataHTTPRequest(latitude: String, longitude: String) -> HTTPRequest {
        let path = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search"
        let queryParams = [
            "apiKey": Self.apiKey,
            "q": "\(latitude)%2C\(longitude)"
        ]
        return HTTPRequest(path: path,
                           queryParams: queryParams)
    }
    
    func getGeoDataSuccess(data: Data, completion: @escaping GetGeoDataHandler) {
        let dataString = String(decoding: data, as: UTF8.self)
        print(dataString)
        let jsonObject = try! JSONSerialization.jsonObject(with: data, options: [])
        print(jsonObject)
    }
    
    func getGeoDataFailure(error: Error, completion: @escaping GetGeoDataHandler) {
        print(error)
    }
    
    // MARK: get24HrHistoricData functions
    
    func get24HrHistoricData() {}
    
    func get24HrHistoricDataHTTPRequest() {}
    
    func get24HrHistoricDataSuccess() {}
    
    func get24HrHistoricDataError() {}
    
    // MARK: get24HrForecast functions
    
    func get24HrForecast() {}
    
    func get24HrForecastHTTPRequest() {}
    
    func get24HrForecastSuccess() {}
    
    func get24HrForecastError() {}
}
