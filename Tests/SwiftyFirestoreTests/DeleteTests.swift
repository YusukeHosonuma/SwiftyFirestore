//
//  DeleteTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/08.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class DeleteTests: FirestoreTestCase {

    override func setUp() {
        super.setUp()
        
        let document = TodoDocument(documentID: "hello", title: "Buy", done: false, priority: 1)
        
        FirestoreDB
            .collection(\.todos)
            .document("hello")
            .setData(document)
    }

    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Swifty 🐤
    
    func testSwifty() {
        // ❌ Delete
        FirestoreDB
            .collection(\.todos)
            .document("hello")
            .delete()

        // ☑️
        waitUntil { done in
            Firestore.firestore()
                .collection("todos")
                .document("hello")
                .getDocument { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️
                    
                    XCTAssertFalse(snapshot.exists)
                    done() // 🔓
                }
        }
    }
    
    func testSwiftyCompletion() {
        // ❌ Delete
        waitUntil { done in
            FirestoreDB
                .collection(\.todos)
                .document("hello")
                .delete { error in
                    XCTAssertNil(error)
                    done() // 🔓
                }
        }

        // ☑️
        waitUntil { done in
            Firestore.firestore()
                .collection("todos")
                .document("hello")
                .getDocument { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️
                    
                    XCTAssertFalse(snapshot.exists)
                    done() // 🔓
                }
        }
    }
    
    // MARK: - Firestore 🔥
    
    func testFirestore() {
        // ❌ Delete
        Firestore.firestore()
            .collection("todos")
            .document("hello")
            .delete()

        // ☑️
        waitUntil { done in
            Firestore.firestore()
                .collection("todos")
                .document("hello")
                .getDocument { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️
                    
                    XCTAssertFalse(snapshot.exists)
                    done() // 🔓
                }
        }
    }
    
    func testFirestoreCompletion() {
        // ❌ Delete
        waitUntil { done in
            Firestore.firestore()
                .collection("todos")
                .document("hello")
                .delete { error in
                    XCTAssertNil(error)
                    done() // 🔓
                }
        }

        // ☑️
        waitUntil { done in
            Firestore.firestore()
                .collection("todos")
                .document("hello")
                .getDocument { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️
                    
                    XCTAssertFalse(snapshot.exists)
                    done() // 🔓
                }
        }
    }
}
