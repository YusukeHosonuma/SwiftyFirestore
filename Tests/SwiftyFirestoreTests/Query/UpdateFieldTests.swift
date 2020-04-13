//
//  UpdateFieldTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/13.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
import FirebaseFirestore
@testable import SwiftyFirestore

class UpdateFieldTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testAsDicrionary() throws {
        let fields: [UpdateField<TodoDocument>] = [
            .value(.title, "Hello"),
            .nestedValue(.info, path: "color", "Red")
        ]
        
        // ⚠️ Note
        // `FieldValue` can't test because not adopted `Equatable` and implementation is hided.
        
        let dictionary = UpdateField.asDicrionary(fields)
        XCTAssertEqual(dictionary["title"] as? String, "Hello")
        XCTAssertEqual(dictionary["info.color"] as? String, "Red")
    }
}
