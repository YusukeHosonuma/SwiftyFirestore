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
    override func setUp() {
        super.setUp()

        let documents = [
            TodoDocument(title: "Apple",  done: false, priority: 1),
            TodoDocument(title: "Banana", done: false, priority: 2),
            TodoDocument(title: "Orange", done: true,  priority: 3),
        ]
        
        for (document, path) in zip(documents, ["one", "two", "three"]) {
            FirestoreDB.collection(\.todos).document(path).setData(document)
        }
    }

    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: 📋
    
    var callCount = 0
    var listener: ListenerRegistration!
    
    var exps: [XCTestExpectation] = []

    // MARK: - 🔧 Test Helper
    
    private func cleanUp() {
        wait(for: exps, timeout: 5)
        wait(time: 0.5) // expect to not trigger listener again
        listener.remove()
    }
    
    // MARK: - ➕ ADD

    // MARK: 🐤 Swifty

    func testAddSwifty() throws {
        defer { cleanUp() } // 🧹
        
        // 📌 Listen
        wait(queue: &exps) { done in
            listener = FirestoreDB
                .collection(\.todos)
                .whereBy(.done, "==", false)
                .listen { result in
                    guard case .success(let (documents, snapshot)) = result else { XCTFail(); return } // ↩️

                    self.callCount += 1
                    
                    switch self.callCount {
                    case 1:
                        XCTAssertEqual(snapshot.documentChanges.count, 2)
                        XCTAssertTrue(snapshot.metadata.hasPendingWrites)
                        XCTAssertEqual(documents.count, 2)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2])
                        
                    case 2:
                        XCTAssertEqual(snapshot.documentChanges.map { $0.type }, [.added])
                        XCTAssertEqual(documents.count, 3)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2, 4])
                        done() // 🔓

                    default:
                        XCTFail("callCount = \(self.callCount)") // 🚫
                    }
                }
        }
        
        // ➕ Add
        try FirestoreDB
            .collection(\.todos)
            .add(TodoDocument(title: "Banana", done: false, priority: 4))

        // ➕ Add (❗ but not triggered to listener because `done` is true)
        try FirestoreDB
            .collection(\.todos)
            .add(TodoDocument(title: "Grape", done: true, priority: 4))
    }
    
    // MARK: 🔥 Firestore

    func testAddFirestore() throws {
        defer { cleanUp() } // 🧹
        
        // 📌 Listen
        wait(queue: &exps) { done in
            listener = Firestore.firestore()
                .collection("todos")
                .whereField("done", isEqualTo: false)
                .addSnapshotListener { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️

                    self.callCount += 1

                    let documents = snapshot.documents.compactMap {
                        try? Firestore.Decoder().decode(TodoDocument.self, from: $0.data())
                    }
                    
                    switch self.callCount {
                    case 1:
                        XCTAssertEqual(snapshot.documentChanges.count, 2)
                        XCTAssertTrue(snapshot.metadata.hasPendingWrites)
                        XCTAssertEqual(documents.count, 2)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2])
                        
                    case 2:
                        XCTAssertEqual(snapshot.documentChanges.map { $0.type }, [.added])
                        XCTAssertEqual(documents.count, 3)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2, 4])
                        done() // 🔓

                    default:
                        XCTFail("callCount = \(self.callCount)") // 🚫
                    }
                }
        }
        
        // ➕ Add
        try FirestoreDB
            .collection(\.todos)
            .add(TodoDocument(title: "Banana", done: false, priority: 4))

        // ➕ Add (❗ but not triggered to listener because `done` is true)
        try FirestoreDB
            .collection(\.todos)
            .add(TodoDocument(title: "Grape", done: true, priority: 4))
    }
    
    // MARK: - 🆙 Update
    
    // MARK: 🐤 Swifty
    
    func testUpdateSwifty() {
        defer { cleanUp() } // 🧹
        
        // 📌 Listen
        wait(queue: &exps) { done in
            listener = FirestoreDB
                .collection(\.todos)
                .whereBy(.done, "==", false)
                .listen { result in
                    guard case .success(let (documents, snapshot)) = result else { XCTFail(); return } // ↩️

                    self.callCount += 1

                    switch self.callCount {
                    case 1:
                        XCTAssertEqual(snapshot.documentChanges.count, 2)
                        XCTAssertTrue(snapshot.metadata.hasPendingWrites)
                        XCTAssertEqual(documents.count, 2)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2])
                        
                    case 2:
                        XCTAssertEqual(snapshot.documentChanges.map { $0.type }, [.modified])
                        XCTAssertEqual(snapshot.documentChanges.map { $0.document.title }, ["🍎"])
                        XCTAssertEqual(documents.count, 2)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2])
                        done() // 🔓

                    default:
                        XCTFail("callCount = \(self.callCount)") // 🚫
                    }
                }
        }
        
        // 🆙 Update
        FirestoreDB
            .collection(\.todos)
            .document("one")
            .update([
                .value(.title, "🍎")
            ])

        // 🆙 Update (❗ but not triggered to listener because `done` is true)
        FirestoreDB
            .collection(\.todos)
            .document("three")
            .update([
                .value(.title, "🍎")
            ])
    }
    
    // MARK: 🔥 Firestore

    func testUpdateFirestore() {
        defer { cleanUp() } // 🧹
        
        // 📌 Listen
        wait(queue: &exps) { done in
            listener = Firestore.firestore()
                .collection("todos")
                .whereField("done", isEqualTo: false)
                .addSnapshotListener { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️

                    self.callCount += 1

                    let documents = snapshot.documents.compactMap {
                        try? Firestore.Decoder().decode(TodoDocument.self, from: $0.data())
                    }
                    
                    switch self.callCount {
                    case 1:
                        XCTAssertEqual(snapshot.documentChanges.count, 2)
                        XCTAssertTrue(snapshot.metadata.hasPendingWrites)
                        XCTAssertEqual(documents.count, 2)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2])
                        
                    case 2:
                        XCTAssertEqual(snapshot.documentChanges.map { $0.type }, [.modified])
                        XCTAssertEqual(snapshot.documentChanges.map { $0.document["title"] as? String }, ["🍎"])
                        XCTAssertEqual(documents.count, 2)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2])
                        done() // 🔓

                    default:
                        XCTFail("callCount = \(self.callCount)") // 🚫
                    }
                }
        }
        
        // 🆙 Update
        FirestoreDB
            .collection(\.todos)
            .document("one")
            .update([
                .value(.title, "🍎")
            ])

        // 🆙 Update (❗ but not triggered to listener because `done` is true)
        FirestoreDB
            .collection(\.todos)
            .document("three")
            .update([
                .value(.title, "🍎")
            ])
    }
    
    // MARK: - ❌ Remove
    
    // MARK: 🐤
    
    func testRemoveSwifty() {
        defer { cleanUp() } // 🧹
        
        // 📌 Listen
        wait(queue: &exps) { done in
            listener = FirestoreDB
                .collection(\.todos)
                .whereBy(.done, "==", false)
                .listen { (result) in
                    guard case .success(let (documents, snapshot)) = result else { XCTFail(); return } // ↩️

                    self.callCount += 1
                    
                    switch self.callCount {
                    case 1:
                        XCTAssertEqual(snapshot.documentChanges.count, 2)
                        XCTAssertTrue(snapshot.metadata.hasPendingWrites)
                        XCTAssertEqual(documents.count, 2)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2])
                        
                    case 2:
                        XCTAssertEqual(snapshot.documentChanges.map { $0.type }, [.removed])
                        XCTAssertEqual(documents.count, 1)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [2])
                        done() // 🔓

                    default:
                        XCTFail("callCount = \(self.callCount)") // 🚫
                    }
                }
        }
        
        // ❌ Remove
        FirestoreDB
            .collection(\.todos)
            .document("one")
            .delete()

        // ❌ Remove (❗ but not triggered to listener because `done` is true)
        FirestoreDB
            .collection(\.todos)
            .document("three")
            .delete()
    }
    
    // MARK: 🔥 Firestore

    func testRemoveFirestore() {
        defer { cleanUp() } // 🧹
        
        // 📌 Listen
        wait(queue: &exps) { done in
            listener = Firestore.firestore()
                .collection("todos")
                .whereField("done", isEqualTo: false)
                .addSnapshotListener { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️

                    self.callCount += 1

                    let documents = snapshot.documents.compactMap {
                        try? Firestore.Decoder().decode(TodoDocument.self, from: $0.data())
                    }
                    
                    switch self.callCount {
                    case 1:
                        XCTAssertEqual(snapshot.documentChanges.count, 2)
                        XCTAssertTrue(snapshot.metadata.hasPendingWrites)
                        XCTAssertEqual(documents.count, 2)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [1, 2])
                        
                    case 2:
                        XCTAssertEqual(snapshot.documentChanges.map { $0.type }, [.removed])
                        XCTAssertEqual(documents.count, 1)
                        XCTAssertEqual(documents.map { $0.priority }.sorted(), [2])
                        done() // 🔓

                    default:
                        XCTFail("callCount = \(self.callCount)") // 🚫
                    }
                }
        }
        
        // ❌ Remove
        FirestoreDB
            .collection(\.todos)
            .document("one")
            .delete()

        // ❌ Remove (❗ but not triggered to listener because `done` is true)
        FirestoreDB
            .collection(\.todos)
            .document("three")
            .delete()
    }
}
