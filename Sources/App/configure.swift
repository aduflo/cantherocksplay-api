import Fluent
import FluentPostgresDriver
import Vapor
import WCTRPCommon

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // setup postgresql db
    if let url = Environment.get("DATABASE_URL"),
       var configuration = PostgresConfiguration(url: url) {
        configuration.tlsConfiguration = .makeClientConfiguration()
        configuration.tlsConfiguration?.certificateVerification = .none
        app.databases.use(.postgres(configuration: configuration), as: .psql, isDefault: true)
        
        // add migrations & seeds
//        app.migrations.add(Migrations(), Seeds())
//        app.logger.logLevel = .debug
    }

    // register routes
    try routes(app)
}
