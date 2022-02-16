//
//  V1Controlling.swift
//  
//
//  Created by Adam Duflo on 1/15/22.
//

import Foundation

protocol V1Controlling {
    /// Returns health report.
    static func getHealth() -> String
}

struct V1Controller: V1Controlling {
    static func getHealth() -> String {
        return "The rocks can play when they are dry :)"
    }
}
