//
//  DataRefreshResponse.swift
//  
//
//  Created by Adam Duflo on 2/27/22.
//

import Vapor

struct DataRefreshResponse: Content {
    let report: DataRefreshReport
}
