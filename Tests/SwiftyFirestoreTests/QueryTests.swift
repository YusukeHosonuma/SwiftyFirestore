//
//  QueryTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/06.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

final class QueryTests: FirestoreTestCase {
    
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

    func testWhere() {
        // `==`
        wait { exp in
            Firestore.root
                .todos
                .whereBy(.priority, isEqualTo: 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [2])
                    exp.fulfill() // 🔓
                }
        }
        
        // `<`
        wait { exp in
            Firestore.root
                .todos
                .whereBy(.priority, isLessThan: 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [1])
                    exp.fulfill() // 🔓
                }
        }
        
        // `<=`
        wait { exp in
            Firestore.root
                .todos
                .whereBy(.priority, isLessThanOrEqualTo: 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [1, 2])
                    exp.fulfill() // 🔓
                }
        }

        // `>`
        wait { exp in
            Firestore.root
                .todos
                .whereBy(.priority, isGreaterThan: 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [3])
                    exp.fulfill() // 🔓
                }
        }
        
        // `>=`
        wait { exp in
            Firestore.root
                .todos
                .whereBy(.priority, isGreaterThanOrEqualTo: 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [2, 3])
                    exp.fulfill() // 🔓
                }
        }
    }
    
    func testOperator() {
        
        // combination + operator
        wait { exp in
            Firestore.root
                .todos
                .whereBy(.done, "==", true)
                .whereBy(.priority, "<=", 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [1])
                    exp.fulfill() // 🔓
                }
        }
    }
}
