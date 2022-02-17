import Vapor

func routes(_ app: Application) throws {
    apiRoute(app)
}

fileprivate func apiRoute(_ app: Application) {
    // MARK: /api
    let apiRoute = app.grouped("api")
    
    v1Route(addedTo: apiRoute)
}

fileprivate func v1Route(addedTo routesBuilder: RoutesBuilder) {
    // MARK: /v1
    let v1Route = routesBuilder.grouped("v1")
    
    // MARK: GET /health
    v1Route.get("health") { request in
        return V1Controller.getHealth()
    }
    .description("Returns health report.")
    
    areasRoute(addedTo: v1Route)
    dataRoute(addedTo: v1Route)
}

fileprivate func areasRoute(addedTo routesBuilder: RoutesBuilder) {
    // MARK: /areas
    let areasRoute = routesBuilder.grouped(AreasMiddleware()).grouped("areas")
    
    // MARK: GET
    areasRoute.get { request -> AreasResponse in
        return AreasController.getAreas()
    }
    .description("Returns list of areas.")
    
    // MARK: GET /:id
    let idParam = "id"
    areasRoute.get(":\(idParam)") { request -> AreasByIdResponse in
        guard let id = request.parameters.get(idParam) else {
            throw Abort(.internalServerError, reason: "Failed to extract {\(idParam)} parameter")
        }
        
        return AreasController.getAreas(id: id)
    }
    .description("Returns area info for {\(idParam)}.")
}

fileprivate func dataRoute(addedTo routesBuilder: RoutesBuilder) {
    // MARK: /data
    let dataRoute = routesBuilder.grouped(DataMiddleware()).grouped("data")
    
    let zoneParam = "zone"
    func extractZone(from request: Request) throws -> Area.Zone {
        guard let zoneValue = request.parameters.get(zoneParam) else {
            throw Abort(.internalServerError, reason: "Failed to extract {\(zoneParam)} parameter")
        }
        
        guard let zone = Area.Zone(rawValue: zoneValue) else {
            let validValues = Area.Zone.allCases.map({ $0.rawValue }).joined(separator: ", ")
            throw Abort(.notFound, reason: "Invalid value for {\(zoneParam)}. Accepted values: \(validValues)")
        }
        
        return zone
    }
    
    // MARK: -
    
    // MARK: /refresh
    let refreshRoute = dataRoute.grouped("refresh")
    
    // MARK: GET
    refreshRoute.get { request -> String in
        return DataController.getRefresh(using: request.client)
    }
    .description("Returns completion status of data refresh task for all zones.")
    
    // MARK: GET /:zone
    refreshRoute.get(":\(zoneParam)") { request -> String in
        return DataController.getRefresh(zone: try extractZone(from: request), using: request.client)
    }
    .description("Returns completion status of data refresh task for {\(zoneParam)}.")
    
    // MARK: -
    
    // MARK: /clear
    let clearRoute = dataRoute.grouped("clear")
    
    // MARK: GET
    clearRoute.get { request -> String in
        return DataController.getClear()
    }
    .description("Returns completion status of data clear task for all zones.")
    
    // MARK: GET /:zone
    clearRoute.get(":\(zoneParam)") { request -> String in
        return DataController.getClear(zone: try extractZone(from: request))
    }
    .description("Returns completion status of data clear task for {\(zoneParam)}.")
}
