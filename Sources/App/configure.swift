import CTRPCommon
import FluentPostgresDriver
import QueuesRedisDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // configure db
    configurePostgresql(using: app)
    addMigrations(using: app)

    // configure jobs
    try configureRedis(using: app)
    scheduleJobs(using: app)

    // register routes
    try routes(app)
}

fileprivate func configurePostgresql(using app: Application) {
    if let url = Environment.get("DATABASE_URL"),
       var configuration = PostgresConfiguration(url: url) {
        configuration.tlsConfiguration = .makeClientConfiguration()
        configuration.tlsConfiguration?.certificateVerification = .none
        app.databases.use(.postgres(configuration: configuration), as: .psql, isDefault: true)
    }
}

fileprivate func addMigrations(using app: Application) {
    app.migrations.add(Migrations(), Seeds())
//    app.logger.logLevel = .debug
}

fileprivate func configureRedis(using app: Application) throws {
    if let url = Environment.get("REDIS_URL") {
        try app.queues.use(.redis(url: url))
    }
}

fileprivate func scheduleJobs(using app: Application) {
    // server time is in UTC
    // hour value equates to 12am in Standard Time for respective Zone
    // scheduling on the half hour
    // job would occur between 12:30-1:30am depending on daylight savings offset
    let hourZoneTuples: [(hour: Int, zone: Zone)] = [
        (5, Zone.eastern),
        (6, Zone.central),
        (7, Zone.mountain),
        (8, Zone.pacific),
    ]
    for tuple in hourZoneTuples {
        app.queues.schedule(DataRefreshJob(zone: tuple.zone))
            .daily()
            .at(.init(integerLiteral: tuple.hour), 30)
    }
}
