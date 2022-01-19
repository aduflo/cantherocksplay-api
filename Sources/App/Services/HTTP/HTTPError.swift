//
//  HTTPError.swift
//  
//
//  Created by Adam Duflo on 1/18/22.
//

import Foundation

enum HTTPError: Error {
    case urlMissing
    case error(Error)
    case urlResponseMissing
    case urlResponseWrongType
    case statusCodeNotSuccess(Int)
    case dataMissing
}
