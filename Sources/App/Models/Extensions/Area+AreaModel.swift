//
//  Area+AreaModel.swift
//  
//
//  Created by Adam Duflo on 3/15/22.
//

import WCTRPCommon

extension Area {
    init(model: AreaModel) {
        self.init(
            id: model.id!,
            name: model.name,
            coordinate: Coordinate(
                latitude: model.latitude,
                longitude: model.longitude
            ),
            zone: model.zone
        )
    }
}
