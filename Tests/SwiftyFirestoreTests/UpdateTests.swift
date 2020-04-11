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
        
        let document = TodoDocument(
            title: "Buy",
            done: false,
            priority: 1,
            tags: ["home", "hobby"],
            remarks: "Note",
            info: [
                "color": "red",
                "size": "14px",
            ]
        )
        
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
        
        // ➕ Update / Add
        documentRef.update([
            .value(.done, true),
            .increment(.priority, 1),
            .arrayUnion(.tags, ["work"]),
            .serverTimestamp(.lastUpdated),
            .nestedValue(.info, path: "color", "blue")
        ])
        
         // ❌ Remove
        documentRef.update([
            .delete(.remarks),
            .arrayRemove(.tags, ["home"])
        ])

        // ✅ Assert
        waitUntil { done in
            Firestore.root
                .todos
                .document("hello")
                .get(completion: { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    
                    self.assert(todo: document)
                    done() // 🔓
                })
        }
    }
    
    func testSwiftyCompletion() {
        // ▶️ Update
        let documentRef = Firestore.root
            .todos
            .document("hello")
        
        // ➕ Update / Add
        waitUntil { done in
            documentRef.update([
                .value(.done, true),
                .increment(.priority, 1),
                .arrayUnion(.tags, ["work"]),
                .nestedValue(.info, path: "color", "blue")
            ]) { error in
                XCTAssertNil(error)
                done() // 🔓
            }
        }
        
        // ❌ Remove
        waitUntil { done in
            documentRef.update([
                .delete(.remarks),
                .arrayRemove(.tags, ["home"])
            ]) { error in
                XCTAssertNil(error)
                done() // 🔓
            }
        }
        
        // ✅ Assert
        waitUntil { done in
            Firestore.root
                .todos
                .document("hello")
                .get(completion: { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    
                    self.assert(todo: document)
                    done() // 🔓
                })
        }
    }
    
    // MARK: - Firestore 🔥
    
    func testFirestore() {
        // ▶️ Update
        let documentRef = Firestore.firestore()
            .collection("todos")
            .document("hello")

        // ➕ Update / Add
        documentRef.updateData([
            "done": true,
            "priority": FieldValue.increment(Int64(1)),
            "tags": FieldValue.arrayUnion(["work"]),
            "lastUpdated": FieldValue.serverTimestamp(), // TODO: can't assert currently
            "info.color": "blue"
        ])

        // ❌ Remove
        documentRef.updateData([
            "remarks": FieldValue.delete(),
            "tags": FieldValue.arrayRemove(["home"])
        ])

        // ✅ Assert
        waitUntil { done in
            Firestore.root
                .todos
                .document("hello")
                .get(completion: { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    
                    self.assert(todo: document)
                    done() // 🔓
                })
        }
    }
    
    func testFirestoreCompletion() {
        // ▶️ Update
        let documentRef = Firestore.firestore()
            .collection("todos")
            .document("hello")
        
        // ➕ Update / Add
        waitUntil { done in
            documentRef.updateData([
                "done": true,
                "priority": FieldValue.increment(Int64(1)),
                "tags": FieldValue.arrayUnion(["work"]),
                "lastUpdated": FieldValue.serverTimestamp(), // TODO: can't assert currently
                "info.color": "blue"
            ]) { error in
                XCTAssertNil(error)
                done() // 🔓
            }
        }
        
        // ❌ Remove
        waitUntil { done in
            documentRef.updateData([
                "remarks": FieldValue.delete(),
                "tags": FieldValue.arrayRemove(["home"])
            ]) { error in
                XCTAssertNil(error)
                done() // 🔓
            }
        }

        // ✅ Assert
        waitUntil { done in
            Firestore.root
                .todos
                .document("hello")
                .get(completion: { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    
                    self.assert(todo: document)
                    done() // 🔓
                })
        }
    }
    
    // MARK: - Helper
    
    func assert(todo: TodoDocument?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(todo?.done, true, "done", file: file, line: line)
        XCTAssertEqual(todo?.priority, 2, "priority", file: file, line: line)
        XCTAssertEqual(todo?.tags, ["hobby", "work"], file: file, line: line)
        XCTAssertNil(todo?.remarks, file: file, line: line)
        XCTAssertEqual(todo?.info, ["color": "blue", "size": "14px"], file: file, line: line)
    }
}
