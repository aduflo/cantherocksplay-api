//
//  DataRefreshByZoneResponse.swift
//  
//
//  Created by Adam Duflo on 2/27/22.
//

import Vapor

struct DataRefreshByZoneResponse: Content {
    let report: DataRefreshReport
}
