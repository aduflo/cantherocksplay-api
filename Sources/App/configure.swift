import Vapor
import WCTRPCommon
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // setup postgres db
    if let url = Environment.get("DATABASE_URL") {
        try app.databases.use(.postgres(url: url), as: .psql)
    }
    
    // initialize supportedAreas
    if let supportedAreas = try? Area.supportedAreas(using: app) {
        app.supportedAreas = supportedAreas
    }

    // register routes
    try routes(app)
}
