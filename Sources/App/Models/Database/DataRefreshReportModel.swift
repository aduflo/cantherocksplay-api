//
//  DataRefreshReportModel.swift
//  
//
//  Created by Adam Duflo on 4/4/22.
//

import FluentKit

final class DataRefreshReportModel: Model {
    static let schema = "data_refresh_reports"

    struct FieldKeys {
        static let createdAt: FieldKey = "created_at"
        static let successes: FieldKey = "successes"
        static let failures: FieldKey = "failures"
    }

    // MARK: Fields

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Field(key: FieldKeys.successes)
    var successes: [String]

    @Field(key: FieldKeys.failures)
    var failures: [String: String]

    // MARK: Constructors

    init() {}

    init(successes: [String],
         failures: [String: String]) {
        self.successes = successes
        self.failures = failures
    }
}
