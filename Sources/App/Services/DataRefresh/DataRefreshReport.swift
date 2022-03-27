//
//  DataRefreshReport.swift
//  
//
//  Created by Adam Duflo on 3/27/22.
//

import Vapor

struct DataRefreshReport: Content {
    let successes: [String]
    let failures: [String: String]
}
