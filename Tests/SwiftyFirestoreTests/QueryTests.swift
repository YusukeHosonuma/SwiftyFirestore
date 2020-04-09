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
        TodoDocument(title: "Apple",  done: false, priority: 3, tags: ["work", "home"]),
        TodoDocument(title: "Banana", done: false, priority: 2, tags: ["work", "hobby"]),
        TodoDocument(title: "Banana", done: true,  priority: 1, tags: ["home"]),
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

    // MARK: - 🐤 Swifty
    
    func testWhere() {
        // `==`
        wait { done in
            Firestore.root
                .todos
                .whereBy(.priority, isEqualTo: 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [2])
                    done() // 🔓
                }
        }
        
        // `<`
        wait { done in
            Firestore.root
                .todos
                .whereBy(.priority, isLessThan: 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [1])
                    done() // 🔓
                }
        }
        
        // `<=`
        wait { done in
            Firestore.root
                .todos
                .whereBy(.priority, isLessThanOrEqualTo: 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [1, 2])
                    done() // 🔓
                }
        }

        // `>`
        wait { done in
            Firestore.root
                .todos
                .whereBy(.priority, isGreaterThan: 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [3])
                    done() // 🔓
                }
        }
        
        // `>=`
        wait { done in
            Firestore.root
                .todos
                .whereBy(.priority, isGreaterThanOrEqualTo: 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [2, 3])
                    done() // 🔓
                }
        }
    }
    
    func testOperator() {
        
        // combination + operator
        wait { done in
            Firestore.root
                .todos
                .whereBy(.done, "==", true)
                .whereBy(.priority, "<=", 2)
                .orderBy(.priority)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    XCTAssertEqual(documents.map { $0.priority }, [1])
                    done() // 🔓
                }
        }
    }
    
    // MARK: - 🐤 arrayContains

    func testArrayContainsSwifty() {
        
        // Method
        wait { done in
            Firestore.root
                .todos
                .whereBy(.tags, arrayContains: "work")
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    
                    XCTAssertEqual(documents.map { $0.priority }.sorted(), [2, 3])
                    done() // 🔓
                }
        }
        
        // Enum
        wait { done in
            Firestore.root
                .todos
                .whereBy(.tags, .arrayContains, "work")
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    
                    XCTAssertEqual(documents.map { $0.priority }.sorted(), [2, 3])
                    done() // 🔓
                }
        }

        // Operator
        wait { done in
            Firestore.root
                .todos
                .whereBy(.tags, "...", "work")
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️
                    
                    XCTAssertEqual(documents.map { $0.priority }.sorted(), [2, 3])
                    done() // 🔓
                }
        }
    }
    
    // MARK: - 🔥 arrayContains
    
    func testArrayContainsFirestore() {
        
        wait { done in
            Firestore.firestore()
                .collection("todos")
                .whereField("tags", arrayContains: "work")
                .getDocuments { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️
                    
                    let documents = snapshot.documents.compactMap {
                        try? Firestore.Decoder().decode(TodoDocument.self, from: $0.data())
                    }
                    
                    XCTAssertEqual(documents.map { $0.priority }.sorted(), [2, 3])
                    done() // 🔓
                }
        }
    }
}
