import Vapor

func routes(_ app: Application) throws {
    
    // /api
    app.group("api") { apiRoute in
        
        // /v1
        apiRoute.group("v1") { v1Route in
            
            // GET health-check
            v1Route.get("health-check") { request in
                return RootController.getHealthCheck()
            }.description("Returns health report.")
            
            // /areas
            v1Route.group("areas") { areasRoute in
                
                // GET
                areasRoute.get { request -> AreasResponse in
                    return AreasController.getAreas()
                }.description("Returns list of supported areas.")
            }
            
            // /area
            v1Route.group("area") { areaRoute in
                
                // GET /:id
                areaRoute.get(":id") { request -> AreaByIdResponse in
                    let id = request.parameters.get("id")!
                    
                    return AreaController.getArea(id: id)
                }.description("Returns area info for associated <id>.")
            }
        }
    }
}
