//
//  ListenTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/07.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class ListenDocumentTests: FirestoreTestCase {

    override func setUp() {
        super.setUp()
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
    
    // MARK: - 🐤 Test to SwiftyFirestore
    
    func testListenSwifty() {
        defer { cleanUp() } // 🧹

        let before = AccountDocument(name: "Yusuke Hosonuma")
        let after  = AccountDocument(name: "Tobi")
        
        // ➕ Add
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(before) { error in
                XCTAssertNil(error)
            }
        
        // 📌 Listen
        wait(queue: &exps) { done in
            listener = Firestore.root
                .account(id: "YusukeHosonuma")
                .listen { result in
                    guard case .success(let (document, metadata)) = result else { XCTFail(); return } // ✅
                    self.callCount += 1

                    switch self.callCount {
                    case 1:
                        XCTAssertTrue(metadata.hasPendingWrites) // TODO: always `true` in first-time❓
                        XCTAssertEqual(document?.name, "Yusuke Hosonuma")
                        
                    case 2:
                        XCTAssertEqual(document?.name, "Tobi")
                        done() // 🔓

                    default:
                        XCTFail("callCount = \(self.callCount)") // 🚫
                    }
                }
        }
        
        // ▶️ Update
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(after) { error in
                XCTAssertNil(error)
            }
    }
    
    func testAddIncludeMetadataChangesSwifty() {
        defer { cleanUp() } // 🧹

        let account = AccountDocument(name: "Yusuke Hosonuma")
        
        // ➕ Add
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(account) { (error) in
                XCTAssertNil(error)
            }
        
        // 📌 Listen
        wait(queue: &exps) { done in
            listener = Firestore.root
                .account(id: "YusukeHosonuma")
                .listen(includeMetadataChanges: true) { result in
                    guard case .success(let (document, _)) = result else { XCTFail(); return } // ↩️
                    
                    self.callCount += 1

                    switch self.callCount {
                    case 1: // initial call
                        XCTAssertEqual(document?.name, "Yusuke Hosonuma")

                    case 2, 3: // data or metadata is update
                        break
                        
                    case 4: // data or metadata is update
                        XCTAssertEqual(document?.name, "Tobi")
                        done()

                    default:
                        XCTFail("callCount = \(self.callCount)") // 🚫
                    }
                }
        }

        // ▶️ Update
        waitUntil { done in
            Firestore.root
                .account(id: "YusukeHosonuma")
                .setData(AccountDocument(name: "Tobi")) { (error) in
                    XCTAssertNil(error)
                    done() // 🔓
                }
        }
    }
    
    func testRemoveSwifty() {
        let before = AccountDocument(name: "Yusuke Hosonuma")
        let after  = AccountDocument(name: "Tobi")
        
        // ➕ Add
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(before) { error in
                XCTAssertNil(error)
            }
        
        // 📌 Listen
        let listener = Firestore.root
            .account(id: "YusukeHosonuma")
            .listen { result in
                guard case .success(_) = result else { XCTFail(); return } // ✅
                self.callCount += 1
                
                if self.callCount >= 2 {
                    XCTFail("`listener` is not removed.")
                }
            }
        
        // ❌ Remove
        listener.remove()

        // ▶️ Update
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(after) { error in
                XCTAssertNil(error)
            }
        
        // ⏳ Wait
        wait(time: 0.5)
    }
    
    // MARK: - 🔥 Test to Firestore API

    func testAddFirestore() {
        defer { cleanUp() } // 🧹

        let account = AccountDocument(name: "Yusuke Hosonuma")
        
        // ➕ Add
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(account) { (error) in
                XCTAssertNil(error)
            }
        
        // 📌 Listen
        wait(queue: &exps) { done in
            listener = Firestore.firestore()
                .collection("account")
                .document("YusukeHosonuma")
                .addSnapshotListener { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return }
                    
                    self.callCount += 1

                    switch self.callCount {
                    case 1:
                        XCTAssertTrue(snapshot.metadata.hasPendingWrites) // TODO: always `true` in first-time❓
                        XCTAssertEqual(snapshot.data()?["name"] as? String, "Yusuke Hosonuma")
                        
                    case 2:
                        XCTAssertEqual(snapshot.data()?["name"] as? String, "Tobi")
                        done()

                    default:
                        XCTFail("callCount = \(self.callCount)") // 🚫
                    }
                }
        }

        // ▶️ Update
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(AccountDocument(name: "Tobi")) { (error) in
                XCTAssertNil(error)
            }
    }

    func testAddIncludeMetadataChangesFirestore() {
        defer { cleanUp() } // 🧹

        let account = AccountDocument(name: "Yusuke Hosonuma")
        
        // ➕ Add
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(account) { (error) in
                XCTAssertNil(error)
            }
        
        // 📌 Listen
        wait(queue: &exps) { done in
            listener = Firestore.firestore()
                .collection("account")
                .document("YusukeHosonuma")
                .addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return }
                    
                    self.callCount += 1

                    switch self.callCount {
                    case 1: // initial call
                        XCTAssertEqual(snapshot.data()?["name"] as? String, "Yusuke Hosonuma")

                    case 2, 3: // data or metadata is update
                        break
                        
                    case 4: // data or metadata is update
                        XCTAssertEqual(snapshot.data()?["name"] as? String, "Tobi")
                        done()

                    default:
                        XCTFail("callCount = \(self.callCount)") // 🚫
                    }
                }
        }

        // ▶️ Update
        waitUntil { done in
            Firestore.root
                .account(id: "YusukeHosonuma")
                .setData(AccountDocument(name: "Tobi")) { (error) in
                    XCTAssertNil(error)
                    done() // 🔓
                }
        }
    }
    
    func testRemoveFirestore() {
        let account = AccountDocument(name: "Yusuke Hosonuma")
        
        // ➕ Add
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(account) { (error) in
                XCTAssertNil(error)
            }
        
        // 📌 Listen
        let listener = Firestore.firestore()
            .collection("account")
            .document("YusukeHosonuma")
            .addSnapshotListener { (snapshot, error) in
                guard let _ = snapshot else { XCTFail(); return }
                
                self.callCount += 1
                
                if self.callCount >= 2 {
                    XCTFail("`listener` is not removed.")
                }
            }
        
        // ❌ Remove
        listener.remove()

        // ▶️ Update
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(AccountDocument(name: "Tobi")) { (error) in
                XCTAssertNil(error)
            }
        
        // ⏳ Wait
        wait(time: 0.5)
    }
}
