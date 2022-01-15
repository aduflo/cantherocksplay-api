import Vapor

func routes(_ app: Application) throws {
    
    // GET health-check
    app.get("health-check") { request in
        return RootController.getHealthCheck()
    }
    
    // /areas route
    app.group("areas") { route in
        
        // GET
        route.get { request -> AreasResponse in
            return AreasController.getAreas()
        }
    }
    
    // /area route
    app.group("area") { route in
        
        // GET /:id
        route.get(":id") { request -> AreaResponse in
            let id = request.parameters.get("id")!
            
            return AreaController.getArea(id: id)
        }
    }
}
