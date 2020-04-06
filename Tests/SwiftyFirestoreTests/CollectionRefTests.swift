//
//  CollectionRefTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/06.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftyFirestore
import Firebase
import FirebaseFirestore

final class CollectionRefeTests: XCTestCase {
    override func setUp() {}
    
    override class func tearDown() {}
    
    func testOrder() {
        FirestoreTestHelper.setupFirebaseApp()
        
        let documents = [
            TodoDocument(documentId: nil, title: "Apple",  done: true, priority: 3),
            TodoDocument(documentId: nil, title: "Banana", done: true, priority: 2),
            TodoDocument(documentId: nil, title: "Banana", done: true, priority: 1),
        ]
        
        for document in documents {
            Firestore.root.todos.add(document)
        }
        
        var exps: [XCTestExpectation] = []
        
        // TODO: refactor - Expectation
        
        // ascending
        do {
            exps.append(expectation(description: "#0"))
            Firestore.root
                .todos
                .orderBy(.priority, sort: .ascending)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return }
                    XCTAssertEqual(documents.count, 3)
                    XCTAssertEqual(documents.map { $0.priority }, [1, 2, 3])
                    exps[0].fulfill()
                }
        }

        // descending
        do {
            exps.append(expectation(description: "#1"))
            Firestore.root
                .todos
                .orderBy(.priority, sort: .descending)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return }
                    XCTAssertEqual(documents.count, 3)
                    XCTAssertEqual(documents.map { $0.priority }, [3, 2, 1])
                    exps[1].fulfill()
                }
        }

        // combination
        do {
            exps.append(expectation(description: "#2"))
            Firestore.root
                .todos
                .orderBy(.title, sort: .ascending)
                .orderBy(.priority, sort: .ascending)
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return }
                    XCTAssertEqual(documents.count, 3)
                    XCTAssertEqual(documents.map { $0.priority }, [3, 1, 2])
                    exps[2].fulfill()
                }
        }
        
        wait(for: exps, timeout: 3)
        
        FirestoreTestHelper.deleteFirebaseApp()
    }
    
    // TODO: limit
}
