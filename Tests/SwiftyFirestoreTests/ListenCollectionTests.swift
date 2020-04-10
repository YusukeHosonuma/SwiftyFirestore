//
//  ListenCollectionTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/10.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class ListenCollectionTests: FirestoreTestCase {

    let documents = [
        TodoDocument(title: "Apple",  done: false, priority: 1),
        TodoDocument(title: "Banana", done: false, priority: 2),
        TodoDocument(title: "Orange", done: true,  priority: 3),
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
    
    // MARK: - ➕ ADD

    // MARK: 🐤 Swifty

    func testAddSwifty() {
        
        var callCount = 0
        var listener: ListenerRegistration!

        func __removeListener() {
            listener.remove() // 🧹 clean-up
        }
        
        var exps: [XCTestExpectation] = []
        defer {
            wait(for: exps, timeout: 5)
            wait(time: 0.5) // expect to not trigger listener again
            __removeListener()
        }
        
        // 📌 Listen
        wait(queue: &exps) { exp in
            listener = Firestore.root
                .todos
                .whereBy(.done, "==", false)
                .listen { result in
                    guard case .success(let (documents, snapshot)) = result else { XCTFail(); return } // ↩️

                    callCount += 1
                    
                    switch callCount {
                    case 1:
                        XCTAssertEqual(snapshot.documentChanges.count, 2)
                        XCTAssertTrue(snapshot.metadata.hasPendingWrites) // TODO: always `true` in first-time❓
                        XCTAssertEqual(documents.count, 2)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2])
                        
                    case 2:
                        XCTAssertEqual(snapshot.documentChanges.map { $0.type }, [.added])
                        XCTAssertEqual(documents.count, 3)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2, 4])
                        exp.fulfill()

                    default:
                        XCTFail("callCount = \(callCount)")
                    }
                }
        }
        
        // ➕ Add
        Firestore.root
            .todos
            .add(TodoDocument(title: "Banana", done: false, priority: 4))

        // ➕ Add (❗ but not triggered to listener because `done` is true)
        Firestore.root
            .todos
            .add(TodoDocument(title: "Grape", done: true, priority: 4))
    }
    
    // MARK: 🔥 Firestore

    func testAddFirestore() {
        
        var callCount = 0
        var listener: ListenerRegistration!

        func __removeListener() {
            listener.remove() // 🧹 clean-up
        }
        
        var exps: [XCTestExpectation] = []
        defer {
            wait(for: exps, timeout: 5)
            wait(time: 0.5) // expect to not trigger listener again
            __removeListener()
        }
        
        // 📌 Listen
        wait(queue: &exps) { exp in
            listener = Firestore.firestore()
                .collection("todos")
                .whereField("done", isEqualTo: false)
                .addSnapshotListener { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️

                    callCount += 1

                    let documents = snapshot.documents.compactMap {
                        try? Firestore.Decoder().decode(TodoDocument.self, from: $0.data())
                    }
                    
                    switch callCount {
                    case 1:
                        XCTAssertEqual(snapshot.documentChanges.count, 2)
                        XCTAssertTrue(snapshot.metadata.hasPendingWrites) // TODO: always `true` in first-time❓
                        XCTAssertEqual(documents.count, 2)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2])
                        
                    case 2:
                        XCTAssertEqual(snapshot.documentChanges.map { $0.type }, [.added])
                        XCTAssertEqual(documents.count, 3)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2, 4])
                        exp.fulfill()

                    default:
                        XCTFail("callCount = \(callCount)")
                    }
                }
        }
        
        // ➕ Add
        Firestore.root
            .todos
            .add(TodoDocument(title: "Banana", done: false, priority: 4))

        // ➕ Add (❗ but not triggered to listener because `done` is true)
        Firestore.root
            .todos
            .add(TodoDocument(title: "Grape", done: true, priority: 4))
    }
}
