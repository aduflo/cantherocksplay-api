import Vapor

func routes(_ app: Application) throws {
    apiRoute(app)
}

fileprivate func apiRoute(_ app: Application) {
    let apiRoute = app.grouped("api")
    
    // /v1
    v1Route(addedTo: apiRoute)
}

fileprivate func v1Route(addedTo routesBuilder: RoutesBuilder) {
    let v1Route = routesBuilder.grouped("v1")
    
    // GET /health-check
    v1Route.get("health") { request in
        return V1Controller.getHealth()
    }
    .description("Returns health report.")
    
    // /areas
    areasRoute(addedTo: v1Route)
    
    // /area
    areaRoute(addedTo: v1Route)
    
    // /data
    dataRoute(addedTo: v1Route)
}

fileprivate func areasRoute(addedTo routesBuilder: RoutesBuilder) {
    let areasRoute = routesBuilder.grouped("areas")
    
    // GET
    areasRoute.get { request -> AreasResponse in
        return AreasController.getAreas()
    }
    .description("Returns list of supported areas.")
}

fileprivate func areaRoute(addedTo routesBuilder: RoutesBuilder) {
    let areaRoute = routesBuilder.grouped("area")
    
    // GET /:id
    let idParameter = "id"
    areaRoute.get(":\(idParameter)") { request -> AreaByIdResponse in
        guard let id = request.parameters.get(idParameter) else {
            throw Abort(.internalServerError, reason: "Failed to extract {\(idParameter)} parameter")
        }
        
        return AreaController.getArea(id: id)
    }
    .description("Returns associated area info for {id}.")
}

fileprivate func dataRoute(addedTo routesBuilder: RoutesBuilder) {
    let dataRoute = routesBuilder.grouped("data")
    
    // /update
    updateRoute(addedTo: dataRoute)
    
    // /clear
    clearRoute(addedTo: dataRoute)
}

fileprivate func updateRoute(addedTo routesBuilder: RoutesBuilder) {
    let updateRoute = routesBuilder.grouped("update")
    
    // GET
    updateRoute.get { request -> String in
        return DataController.getUpdate(using: request.client)
    }
    .description("Returns completion status of data update task for all zones.")
    
    // GET /:zone
    let zoneParameter = "zone"
    updateRoute.get(":\(zoneParameter)") { request -> String in
        guard let zoneValue = request.parameters.get(zoneParameter) else {
            throw Abort(.internalServerError, reason: "Failed to extract {\(zoneParameter)} parameter")
        }
        
        guard let zone = Area.Zone(rawValue: zoneValue) else {
            let validValues = Area.Zone.allCases.map({ $0.rawValue }).joined(separator: ", ")
            throw Abort(.notFound, reason: "Invalid value for {\(zoneParameter)}. Accepted values: \(validValues)")
        }
        
        return DataController.getUpdate(zone: zone, using: request.client)
    }
    .description("Returns completion status of data update task for {zone}.")
}

fileprivate func clearRoute(addedTo routesBuilder: RoutesBuilder) {
    let clearRoute = routesBuilder.grouped("clear")
    
    // GET
    clearRoute.get { request -> String in
        return DataController.getClear()
    }
    .description("Returns completion status of data clear task for all zones.")
    
    // GET /:zone
    let zoneParameter = "zone"
    clearRoute.get(":\(zoneParameter)") { request -> String in
        guard let zoneValue = request.parameters.get(zoneParameter) else {
            throw Abort(.internalServerError, reason: "Failed to extract {\(zoneParameter)} parameter")
        }
        
        guard let zone = Area.Zone(rawValue: zoneValue) else {
            let validValues = Area.Zone.allCases.map({ $0.rawValue }).joined(separator: ", ")
            throw Abort(.notFound, reason: "Invalid value for {\(zoneParameter)}. Accepted values: \(validValues)")
        }
        
        return DataController.getClear(zone: zone)
    }
    .description("Returns completion status of data clear task for {zone}.")
}
