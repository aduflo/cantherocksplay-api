import CTRPCommon
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
    v1Route.get("health") { request -> V1HealthResponse in
        return try await V1Controller.getHealth(using: request.application)
    }
    .description("Returns health report.")
    
    areasRoute(addedTo: v1Route)
}

fileprivate func areasRoute(addedTo routesBuilder: RoutesBuilder) {
    // MARK: /areas
    let areasRoute = routesBuilder.grouped(AreasMiddleware()).grouped("areas")
    
    // MARK: GET
    areasRoute.get { request -> AreasResponse in
        return try await AreasController.getAreas(using: request.db)
    }
    .description("Returns list of areas.")
    
    // MARK: GET /:id
    let idParam = "id"
    areasRoute.get(":\(idParam)") { request -> AreasByIdResponse in
        guard let id = request.parameters.get(idParam, as: UUID.self) else {
            throw Abort(.internalServerError, reason: "Failed to extract {\(idParam)} parameter")
        }
        
        return try await AreasController.getAreasById(id, using: request.db)
    }
    .description("Returns area info for {\(idParam)}.")
}
