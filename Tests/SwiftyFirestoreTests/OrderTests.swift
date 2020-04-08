//
//  OrderTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/08.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class OrderTests: FirestoreTestCase {

    let documents = [
        TodoDocument(title: "Apple",  done: false, priority: 3),
        TodoDocument(title: "Banana", done: false, priority: 2),
        TodoDocument(title: "Banana", done: true,  priority: 1),
    ]
    
    override func setUp() {
        super.setUp()
        
        for document in documents {
            Firestore.root.todos.add(document)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testOrder() {
        // 🔼 ascending
        wait { exp in
            Firestore.root
                .todos
                .orderBy(.priority, sort: .ascending)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [1, 2, 3])
                    exp.fulfill() // 🔓
                }
        }

        // 🔽 descending
        wait { exp in
            Firestore.root
                .todos
                .orderBy(.priority, sort: .descending)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [3, 2, 1])
                    exp.fulfill() // 🔓
                }
        }

        // ➕ combination
        wait { exp in
            Firestore.root
                .todos
                .orderBy(.title, sort: .ascending)
                .orderBy(.priority, sort: .ascending)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [3, 1, 2])
                    exp.fulfill() // 🔓
                }
        }
    }
    
    func testLimit() {
        // ⤴️ limit(to:)
        wait { exp in
            Firestore.root
                .todos
                .orderBy(.priority, sort: .ascending)
                .limitTo(2)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [1, 2])
                    exp.fulfill() // 🔓
                }
        }
        
        // ⤴️ limit(toLast:)
        wait { exp in
            Firestore.root
                .todos
                .orderBy(.priority, sort: .ascending)
                .limitToLast(2)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [2, 3])
                    exp.fulfill() // 🔓
                }
        }
    }
}
