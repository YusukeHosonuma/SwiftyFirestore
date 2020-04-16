//
//  AddDocumentTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/12.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class AddDocumentTests: FirestoreTestCase {

    let document = TodoDocument(title: "🍎", done: false)
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Add
    
    // MARK: 🐤 Swifty

    func testAddSwifty() throws {
        let ref = try FirestoreDB
            .collection(\.todos)
            .add(document) { _ in }
        
        waitUntil { done in
            ref.get { result in
                guard case .success(let document) = result else { XCTFail(); return } // ↩️
                
                self.assertAdd(document)
                done() // 🔓
            }
        }
    }

    // MARK: 🔥 Firestore
    
    func testAddFirestore() throws {
        let ref = try Firestore.firestore()
            .collection("todos")
            .addDocument(from: document) { _ in }
        
        waitUntil { done in
            ref.getDocument { (snapshot, error) in
                guard let snapshot = snapshot else { XCTFail(); return } // ↩️
                
                let document = try? snapshot.data(as: TodoDocument.self)
                
                self.assertAdd(document)
                done() // 🔓
            }
        }
    }
    
    // MARK: ✅ Assert
    
    func assertAdd(_ document: TodoDocument?) {
        XCTAssertNotNil(document)
        XCTAssertEqual(document?.title, "🍎")
    }
}
