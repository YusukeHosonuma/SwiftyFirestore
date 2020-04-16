//
//  AliasTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/10.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

#if swift(>=5.2) // 🐤 Use `callAsFunction` in Swift 5.2
class AliasTests: FirestoreTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCallAsFunction() throws {
        let document = TodoDocument(title: "🍎", done: false, priority: 1)

        // ➕ Add
        FirestoreDB
            .collection(\.todos)(path: "apple") // 🐤 callAsFunction
            .setData(document)
        
        // ✅ Assert
        waitUntil { done in
            FirestoreDB
                .collection(\.todos)(path: "apple")
                .get { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(document?.title, "🍎")
                    done() // 🔓
                }
        }
    }
}
#endif
