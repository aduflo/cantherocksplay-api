//
//  DataRefreshJob.swift
//  
//
//  Created by Adam Duflo on 4/3/22.
//

import CTRPCommon
import Queues

struct DataRefreshJob: AsyncScheduledJob {
    let zone: Zone
    
    func run(context: QueueContext) async throws {
        try await DataController.refreshWeatherData(for: zone, using: context.application)
    }
}
