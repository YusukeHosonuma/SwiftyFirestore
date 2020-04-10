//
//  BatchTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/10.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class BatchTests: FirestoreTestCase {

    override func setUp() {
        super.setUp()
        
        let documents: [String: TodoDocument] = [
            "apple" : TodoDocument(title: "🍎", done: false),
            "orange": TodoDocument(title: "🍊", done: false),
        ]
        
        for (path, document) in documents {
            Firestore.firestore()
                .collection("todos")
                .document(path)
                .setData(try! Firestore.Encoder().encode(document))
        }
    }
    
    // MARK: - 🐤 Swifty

    func testSwifty() throws {
        
        let batch = Firestore.batch()
        
        // ➕ Add - `banana`
        do {
            let ref = Firestore.root.todos.document("banana")
            let document = TodoDocument(title: "🍌", done: false)
            try batch.setData(ref: ref, document)
        }
        
        // 🆙 Update - `apple`
        do {
            let ref = Firestore.root.todos.document("apple")
            batch.update(ref: ref, [.value(.done, true)])
        }
        
        // ❌ Delete - `orange`
        do {
            let ref = Firestore.root.todos.document("orange")
            batch.delete(ref: ref)
        }

        // ✏️ Commit
        waitUntil { done in
            batch.commit { error in
                XCTAssertNil(error)
                done() // 🔓
            }
        }
        
        // ✅ Asserts
        do {
            // ➕ Added
            waitUntil { done in
                Firestore.root.todos.document("banana").get { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️

                    XCTAssertEqual(document?.title, "🍌")
                    done() // 🔓
                }
            }
            
            // 🆙 Updated
            waitUntil { done in
                Firestore.root.todos.document("apple").get { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️

                    XCTAssertEqual(document?.done, true)
                    done() // 🔓
                }
            }
            
            
            // ❌ Deleted
            waitUntil { done in
                Firestore.root.todos.document("orange").get { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️

                    XCTAssertNil(document)
                    done() // 🔓
                }
            }
        }
    }

    // MARK: - Firestore 🔥

    func testFirestore() {
        
        let batch = Firestore.firestore().batch()
        
        // ➕ Add - `banana`
        do {
            let ref = Firestore.firestore().collection("todos").document("banana")
            let document = TodoDocument(title: "🍌", done: false)
            batch.setData(try! Firestore.Encoder().encode(document), forDocument: ref)
        }
        
        // 🆙 Update - `apple`
        do {
            let ref = Firestore.firestore().collection("todos").document("apple")
            batch.updateData(["done": true], forDocument: ref)
        }
        
        // ❌ Delete - `orange`
        do {
            let ref = Firestore.firestore().collection("todos").document("orange")
            batch.deleteDocument(ref)
        }

        // ✏️ Commit
        waitUntil { done in
            batch.commit { error in
                XCTAssertNil(error)
                done() // 🔓
            }
        }
        
        // ✅ Asserts
        do {
            // ➕ Added
            waitUntil { done in
                Firestore.root.todos.document("banana").get { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️

                    XCTAssertEqual(document?.title, "🍌")
                    done() // 🔓
                }
            }
            
            // 🆙 Updated
            waitUntil { done in
                Firestore.root.todos.document("apple").get { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️

                    XCTAssertEqual(document?.done, true)
                    done() // 🔓
                }
            }
            
            
            // ❌ Deleted
            waitUntil { done in
                Firestore.root.todos.document("orange").get { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️

                    XCTAssertNil(document)
                    done() // 🔓
                }
            }
        }
    }
}
