//
//  TransactionTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/10.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class TransactionTests: FirestoreTestCase {

    override func setUp() {
        super.setUp()
        
        let document = TodoDocument(title: "Buy", done: false, priority: 1)
        
        Firestore.firestore()
            .collection("todos")
            .document("hello")
            .setData(try! Firestore.Encoder().encode(document))
        
        wait(time: 0.5) // TDOO: why needed❓
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: 🐤 Swifty
    
    func testSwifty() {
        let todoReference = FirestoreDB.collection(\.todos).document("hello")
        
        // 🔏 Transaction
        waitUntil { done in
            FirestoreDB.runTransaction({ (transaction, errorPointer) -> Int? in
                let maybeDocument: TodoDocument?
                do {
                    maybeDocument = try transaction.get(todoReference)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let document = maybeDocument else {
                    let error = NSError(
                        domain: "AppErrorDomain",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Document is not exists."
                        ]
                    )
                    errorPointer?.pointee = error
                    return nil
                }
                
                let newPriority = document.priority + 1
                do {
                    try transaction.update(for: todoReference) {
                        $0.update(.priority, path: \.priority, newPriority)
                    }
                } catch let error as NSError {
                    errorPointer?.pointee = error
                    return nil
                }
                
                return newPriority
            }) { result in
                guard case .success(let newPriority) = result else { XCTFail(); return } // ↩️
                XCTAssertEqual(newPriority, 2)
                done() // 🔓
            }
        }
        
        // 🔍 Get
        waitUntil { done in
            todoReference.ref.getDocument { (snapshot, error) in
                guard let snapshot = snapshot else { XCTFail(); return } // ↩️

                XCTAssertEqual(snapshot.data()?["priority"] as? Int, 2)
                done() // 🔓
            }
        }
    }
    
    // MARK: 🔥 Firestore
    
    func testFirestore() {
        
        let todoReference = Firestore.firestore().collection("todos").document("hello")
        
        // 🔏 Transaction
        waitUntil { done in
            Firestore.firestore()
                .runTransaction({ (transaction, errorPointer) -> Any? in
                    
                    let document: DocumentSnapshot
                    do {
                        document = try transaction.getDocument(todoReference)
                    } catch let fetchError as NSError {
                        errorPointer?.pointee = fetchError
                        return nil
                    }
                    
                    guard let oldPriority = document.data()?["priority"] as? Int else {
                        let error = NSError(
                            domain: "AppErrorDomain",
                            code: -1,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Unable to retrieve `priority` from snapshot \(document)"
                            ]
                        )
                        errorPointer?.pointee = error
                        return nil
                    }
                    
                    let newPriority = oldPriority + 1
                    transaction.updateData(["priority": newPriority], forDocument: todoReference)
                    return newPriority
                }) { (newPriority, error) in
                    XCTAssertNil(error)
                    XCTAssertEqual(newPriority as? Int, 2)
                    done() // 🔓
                }
        }
        
        // 🔍 Get
        waitUntil { done in
            todoReference.getDocument { (snapshot, error) in
                guard let snapshot = snapshot else { XCTFail(); return } // ↩️

                XCTAssertEqual(snapshot.data()?["priority"] as? Int, 2)
                done() // 🔓
            }
        }
    }
}
