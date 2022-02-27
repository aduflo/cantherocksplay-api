import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // initialize supportedAreas
    app.supportedAreas = try Area.supportedAreas(using: app)

    // register routes
    try routes(app)
}
