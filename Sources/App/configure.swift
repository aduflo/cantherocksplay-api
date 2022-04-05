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
    let hoursFromGMT = TimeZone.current.secondsFromGMT()/60/60
    let dstOffsetInHours = Int(TimeZone.current.daylightSavingTimeOffset()/60/60)
    let hoursFromGMTInStandardTime = hoursFromGMT + -dstOffsetInHours
    let hourZoneTuples: [(hour: Int, zone: Zone)]?
    switch hoursFromGMTInStandardTime {
    case -5: // Eastern Standard Time
        hourZoneTuples = [(1, .eastern), (2, .central), (3, .mountain), (4, .pacific)]
    case -6: // Central Standard Time
        hourZoneTuples = [(0, .eastern), (1, .central), (2, .mountain), (3, .pacific)]
    case -7: // Mountain Standard Time
        hourZoneTuples = [(23, .eastern), (0, .central), (1, .mountain), (2, .pacific)]
    case -8: // Pacific Standard Time
        hourZoneTuples = [(22, .eastern), (23, .central), (0, .mountain), (1, .pacific)]
    default:
        hourZoneTuples = nil
    }
    
    guard let hourZoneTuples = hourZoneTuples else {
        return
    }

    for tuple in hourZoneTuples {
        app.queues.schedule(DataRefreshJob(zone: tuple.zone))
            .daily()
            .at(.init(integerLiteral: tuple.hour), 0)
    }
}
