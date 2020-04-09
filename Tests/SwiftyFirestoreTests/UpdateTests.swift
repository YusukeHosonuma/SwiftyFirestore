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
        
        let document = TodoDocument(documentId: "hello", title: "Buy", done: false, priority: 1, tags: ["home", "hobby"])
        
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
        // ▶️ Update
        let documentRef = Firestore.root
            .todos
            .document("hello")
        
        documentRef.update([
            .value(.done, true),
            .increment(.priority, 1),
            .arrayUnion(.tags, ["work"]) // ➕ Union
        ])
        
        documentRef.update([
            .arrayRemove(.tags, ["home"]) // ❌ Remove
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
        // ▶️ Update
        let documentRef = Firestore.root
            .todos
            .document("hello")
        
        wait { exp in
            documentRef.update([
                .value(.done, true),
                .increment(.priority, 1),
                .arrayUnion(.tags, ["work"]) // ➕ Union
            ]) { error in
                XCTAssertNil(error)
                exp.fulfill() // 🔓
            }
        }
        
        wait { exp in
            documentRef.update([
                .arrayRemove(.tags, ["home"]) // ❌ Remove
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
        // ▶️ Update
        let documentRef = Firestore.firestore()
            .collection("todos")
            .document("hello")
            
        documentRef.updateData([
            "done": true,
            "priority": FieldValue.increment(Int64(1)),
            "tags": FieldValue.arrayUnion(["work"]) // ➕ Union
        ])
            
        documentRef.updateData([
            "tags": FieldValue.arrayRemove(["home"]) // ❌ Remove
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
        // ▶️ Update
        let documentRef = Firestore.firestore()
            .collection("todos")
            .document("hello")
        
        wait { exp in
            documentRef.updateData([
                "done": true,
                "priority": FieldValue.increment(Int64(1)),
                "tags": FieldValue.arrayUnion(["work"]) // ➕ Union
            ]) { error in
                XCTAssertNil(error)
                exp.fulfill() // 🔓
            }
        }
        
        wait { exp in
            documentRef.updateData([
                "tags": FieldValue.arrayRemove(["home"]) // ❌ Remove
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
        XCTAssertEqual(todo?.tags, ["hobby", "work"], file: file, line: line)
    }
}
