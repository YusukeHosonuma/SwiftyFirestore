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
            info: TodoDocument.Info(
                color: "red",
                size: 14
            ),
            color: .red
        )
        
        Firestore.firestore()
            .collection("todos")
            .document("hello")
            .setData(try! Firestore.Encoder().encode(document))
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Update fields
    
    // MARK: 🐤 Swifty

    func testSwifty() throws {
        // ▶️ Update
        let documentRef = FirestoreDB
            .collection(\.todos)
            .document("hello")
        
        // ➕ Update / Add
        waitUntil { done in
            try! documentRef.update(fields: {
                $0.update(.done, path: \.done, true)
                $0.increment(.priority, path: \.priority, 1)
                $0.arrayUnion(.tags, path: \.tags, ["work"])
                $0.nestedValue("info.color", "blue")
            }){ error in
                XCTAssertNil(error)
                done() // 🔓
            }
        }

        // ❌ Removes
        waitUntil { done in
            try! documentRef.update(fields: {
                $0.delete(.remarks)
                $0.arrayRemove(.tags, path: \.tags, ["home"])
            }) { error in
                XCTAssertNil(error)
                done() // 🔓
            }
        }
        
        // ✅ Assert
        waitUntil { done in
            FirestoreDB
                .collection(\.todos)
                .document("hello")
                .get(completion: { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    
                    self.assert(todo: document)
                    done() // 🔓
                })
        }
    }
    
    // MARK: 🔥 Firestore

    func testFirestore() {
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
            FirestoreDB
                .collection(\.todos)
                .document("hello")
                .get(completion: { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    
                    self.assert(todo: document)
                    done() // 🔓
                })
        }
    }
    
    func assert(todo: TodoDocument?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(todo?.done, true, "done", file: file, line: line)
        XCTAssertEqual(todo?.priority, 2, "priority", file: file, line: line)
        XCTAssertEqual(todo?.tags, ["hobby", "work"], file: file, line: line)
        XCTAssertNil(todo?.remarks, file: file, line: line)
        XCTAssertEqual(todo?.info, TodoDocument.Info(color: "blue", size: 14), file: file, line: line)
    }
    
    // MARK: - Struct
    
    // MARK: 🐤 Swifty
    
    func testStructSwifty() throws {
        let documentRef = FirestoreDB
            .collection(\.todos)
            .document("hello")
        
        // ➕ Update
        try documentRef.update {
            $0.update(.info, path: \.info, TodoDocument.Info(color: "blue", size: 12))
        }
        
        // ✅ Assert
        waitUntil { done in
            FirestoreDB
                .collection(\.todos)
                .document("hello")
                .get(completion: { result in
                    guard case .success(let todo) = result else { XCTFail(); return } // ↩️
                    
                    self.assertStruct(todo: todo)
                    done() // 🔓
                })
        }
    }
    
    // MARK: 🔥 Firestore
    
    func testStructFirestore() {
        let documentRef = Firestore.firestore()
            .collection("todos")
            .document("hello")
        
        // ➕ Update
        documentRef.updateData([
            "info": [
                "color": "blue",
                "size": 12
            ]
        ])
        
        // ✅ Assert
        waitUntil { done in
            FirestoreDB
                .collection(\.todos)
                .document("hello")
                .get(completion: { result in
                    guard case .success(let todo) = result else { XCTFail(); return } // ↩️
                    
                    self.assertStruct(todo: todo)
                    done() // 🔓
                })
        }
    }
    
    func assertStruct(todo: TodoDocument?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(todo?.info, TodoDocument.Info(color: "blue", size: 12), file: file, line: line)
    }
    
    // MARK: - Enum
    
    // MARK: 🐤 Swifty
    
    func testEnumSwifty() throws {
        let documentRef = FirestoreDB
            .collection(\.todos)
            .document("hello")
        
        // ➕ Update
        try documentRef.update {
            $0.update(.color, path: \.color, .blue)
        }
        
        // ✅ Assert
        waitUntil { done in
            FirestoreDB
                .collection(\.todos)
                .document("hello")
                .get(completion: { result in
                    guard case .success(let todo) = result else { XCTFail(); return } // ↩️
                    
                    self.assertEnum(todo: todo)
                    done() // 🔓
                })
        }
    }
    
    // MARK: 🔥 Firestore
    
    func testEnumFirestore() {
        let documentRef = Firestore.firestore()
            .collection("todos")
            .document("hello")
        
        // ➕ Update
        documentRef.updateData([
            "color": "blue"
        ])
        
        // ✅ Assert
        waitUntil { done in
            FirestoreDB
                .collection(\.todos)
                .document("hello")
                .get(completion: { result in
                    guard case .success(let todo) = result else { XCTFail(); return } // ↩️
                    
                    self.assertEnum(todo: todo)
                    done() // 🔓
                })
        }
    }
    
    func assertEnum(todo: TodoDocument?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(todo?.color, .blue, file: file, line: line)
    }
}
