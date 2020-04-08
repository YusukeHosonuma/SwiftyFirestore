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
        
        let document = TodoDocument(documentId: "hello", title: "Buy", done: false, priority: 1)
        
        Firestore.root
            .todos
            .document("hello")
            .setData(document)
    }

    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Swifty 🐤
    
    func testSwifty() {
        // ❌ Delete
        Firestore.root
            .todos
            .document("hello")
            .delete()

        // ☑️
        wait { exp in
            Firestore.firestore()
                .collection("todos")
                .document("hello")
                .getDocument { (snapshot, error) in // TODO: test `isExists`
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️
                    
                    XCTAssertFalse(snapshot.exists)
                    exp.fulfill() // 🔓
                }
        }
    }
    
    func testSwiftyCompletion() {
        // ❌ Delete
        wait { exp in
            Firestore.root
                .todos
                .document("hello")
                .delete { error in
                    XCTAssertNil(error)
                    exp.fulfill() // 🔓
                }
        }

        // ☑️
        wait { exp in
            Firestore.firestore()
                .collection("todos")
                .document("hello")
                .getDocument { (snapshot, error) in // TODO: test `isExists`
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️
                    
                    XCTAssertFalse(snapshot.exists)
                    exp.fulfill() // 🔓
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
        wait { exp in
            Firestore.firestore()
                .collection("todos")
                .document("hello")
                .getDocument { (snapshot, error) in // TODO: test `isExists`
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️
                    
                    XCTAssertFalse(snapshot.exists)
                    exp.fulfill() // 🔓
                }
        }
    }
    
    func testFirestoreCompletion() {
        // ❌ Delete
        wait { exp in
            Firestore.firestore()
                .collection("todos")
                .document("hello")
                .delete { error in
                    XCTAssertNil(error)
                    exp.fulfill() // 🔓
                }
        }

        // ☑️
        wait { exp in
            Firestore.firestore()
                .collection("todos")
                .document("hello")
                .getDocument { (snapshot, error) in // TODO: test `isExists`
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️
                    
                    XCTAssertFalse(snapshot.exists)
                    exp.fulfill() // 🔓
                }
        }
    }
}
