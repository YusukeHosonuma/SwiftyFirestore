//
//  UpdateTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/08.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class UpdateTests: FirestoreTestCase {

    override func setUp() {
        super.setUp()
        
        let document = TodoDocument(documentId: "hello", title: "Buy", done: false, priority: 1)
        
        Firestore.firestore()
            .collection("todos")
            .document("hello")
            .setData(try! Firestore.Encoder().encode(document))
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Swifty 🐤
    
    func testSwifty() {
        defer { waitExpectations() } // ⏳
        
        // ▶️ Update
        Firestore.root
            .todos
            .document("hello")
            .update([
                (.done, true),
                (.priority, 2)
            ])
        
        // ✅ Assert
        wait { exp in
            Firestore.root
                .todos
                .document("hello")
                .get(completion: { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    
                    self.assert(todo: document)
                    exp.fulfill() // 🔓
                })
        }
    }
    
    func testSwiftyCompletion() {
        defer { waitExpectations() } // ⏳
        
        // ▶️ Update
        wait { exp in
            Firestore.root
                .todos
                .document("hello")
                .update([
                    (.done, true),
                    (.priority, 2)
                ]) { error in
                    XCTAssertNil(error)
                    exp.fulfill() // 🔓
                }
        }
        
        // ✅ Assert
        wait { exp in
            Firestore.root
                .todos
                .document("hello")
                .get(completion: { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    
                    self.assert(todo: document)
                    exp.fulfill() // 🔓
                })
        }
    }
    
    // MARK: - Firestore 🔥
    
    func testFirestore() {
        defer { waitExpectations() } // ⏳
        
        // ▶️ Update
        Firestore.firestore()
            .collection("todos")
            .document("hello")
            .updateData([
                "done": true,
                "priority": 2
            ])
        
        // ✅ Assert
        wait { exp in
            Firestore.root
                .todos
                .document("hello")
                .get(completion: { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    
                    self.assert(todo: document)
                    exp.fulfill() // 🔓
                })
        }
    }
    
    func testFirestoreCompletion() {
        defer { waitExpectations() } // ⏳
        
        // ▶️ Update
        wait { exp in
            Firestore.firestore()
                .collection("todos")
                .document("hello")
                .updateData([
                    "done": true,
                    "priority": 2
                ]) { error in
                    XCTAssertNil(error)
                    exp.fulfill() // 🔓
                }
        }
        
        // ✅ Assert
        wait { exp in
            Firestore.root
                .todos
                .document("hello")
                .get(completion: { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    
                    self.assert(todo: document)
                    exp.fulfill() // 🔓
                })
        }
    }
    
    // MARK: - Helper
    
    func assert(todo: TodoDocument?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(todo?.done, true, "done", file: file, line: line)
        XCTAssertEqual(todo?.priority, 2, "priority", file: file, line: line)
    }
}
