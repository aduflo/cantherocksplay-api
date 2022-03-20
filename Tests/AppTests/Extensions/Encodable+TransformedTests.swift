//
//  Encodable+TransformedTests.swift
//  
//
//  Created by Adam Duflo on 3/15/22.
//

import XCTest

fileprivate struct SingleLevelEncodable: Encodable {
    let id: String
}

fileprivate struct MultiLevelEncodable: Encodable {
    let id: Int
    let levels: [MultiLevelEncodable]
}

fileprivate struct InvalidEncodable: Encodable {
    let id: Double = .nan // .nan or .infinity are not encodable values
}

class Encodable_TransformedTests: XCTestCase {
    
    // MARK: Reusable Constants
    
    fileprivate let singleLevelEncodable = SingleLevelEncodable(id: "id")
    fileprivate let multiLevelEncodable = MultiLevelEncodable(
        id: 0,
        levels: [
            .init(
                id: 1, levels: []
            ),
            .init(
                id: 2,
                levels: [
                    .init(
                        id: 20,
                        levels: []
                    ),
                ]
            )
        ]
    )
    fileprivate let invalidEncodable = InvalidEncodable()
    
    // MARK: toJSONData()
    
    func test_toJSONData_with_singleLevelEncodable() {
        // Verification
        XCTAssertNotNil(try singleLevelEncodable.toJSONData())
    }
    
    func test_toJSONData_with_multiLevelEncodable() {
        // Verification
        XCTAssertNotNil(try multiLevelEncodable.toJSONData())
    }
    
    func test_toJSONData_with_invalidEncodable() {
        // Verification
        XCTAssertThrowsError(try invalidEncodable.toJSONData())
    }
    
    // MARK: toJSONString()
    
    func test_toJSONString_with_singleLevelEncodable() {
        // Setup
        let jsonString = singleLevelEncodable.toJSONString()
        
        // Verification
        XCTAssertEqual(jsonString, "{\"id\":\"id\"}")
    }
    
    func test_toJSONString_with_multiLevelEncodable() {
        // Setup
        let jsonString = multiLevelEncodable.toJSONString()

        // Verification
        XCTAssertEqual(jsonString, "{\"id\":0,\"levels\":[{\"id\":1,\"levels\":[]},{\"id\":2,\"levels\":[{\"id\":20,\"levels\":[]}]}]}")
    }
    
    func test_toJSONString_with_invalidEncodable() {
        // Setup
        let jsonString = invalidEncodable.toJSONString()
        
        // Verification
        XCTAssertNil(jsonString)
    }
}
