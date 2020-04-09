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

class ListenTests: FirestoreTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - 🐤 Test to SwiftyFirestore
    
    func testListenSwifty() {
        defer { waitExpectations() } // ⏳

        let before = AccountDocument(name: "Yusuke Hosonuma")
        let after  = AccountDocument(name: "Tobi")
        
        // ➕ Add
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(before) { error in
                XCTAssertNil(error)
            }

        var callCount = 0
        var listener: ListenerRegistration!
        
        func __removeListener() {
            listener.remove() // 🧹 clean-up
        }
        
        // 📌 Listen
        addWait { exp in
            listener = Firestore.root
                .account(id: "YusukeHosonuma")
                .listen { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ✅
                    callCount += 1

                    switch callCount {
                    case 1:
                        XCTAssertEqual(document?.name, "Yusuke Hosonuma")
                        
                    case 2:
                        XCTAssertEqual(document?.name, "Tobi")
                        __removeListener()
                        exp.fulfill() // 🔓

                    default:
                        XCTFail()
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
        defer { waitExpectations() } // ⏳

        let account = AccountDocument(name: "Yusuke Hosonuma")
        
        // ➕ Add
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(account) { (error) in
                XCTAssertNil(error)
            }

        var callCount = 0
        var listener: ListenerRegistration!
        
        func __removeListener() {
            listener.remove() // 🧹 clean-up
        }
        
        // 📌 Listen
        addWait { exp in
            listener = Firestore.root
                .account(id: "YusukeHosonuma")
                .listen(includeMetadataChanges: true) { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️
                    
                    callCount += 1

                    switch callCount {
                    case 1: // initial call
                        XCTAssertEqual(document?.name, "Yusuke Hosonuma")

                    case 2: // data or metadata is update
                        break
                        
                    case 3: // data or metadata is update
                        XCTAssertEqual(document?.name, "Tobi")
                        __removeListener()
                        exp.fulfill()

                    default:
                        XCTFail()
                    }
                }
        }

        // ▶️ Update
        wait { exp in
            Firestore.root
                .account(id: "YusukeHosonuma")
                .setData(AccountDocument(name: "Tobi")) { (error) in
                    XCTAssertNil(error)
                    exp.fulfill()
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

        var callCount = 0
        
        // 📌 Listen
        let listener = Firestore.root
            .account(id: "YusukeHosonuma")
            .listen { result in
                guard case .success(_) = result else { XCTFail(); return } // ✅
                callCount += 1
                
                if callCount >= 2 {
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
        defer { waitExpectations() } // ⏳

        let account = AccountDocument(name: "Yusuke Hosonuma")
        
        // ➕ Add
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(account) { (error) in
                XCTAssertNil(error)
            }

        var callCount = 0
        var listener: ListenerRegistration!

        func __removeListener() {
            listener.remove() // 🧹 clean-up
        }

        // 📌 Listen
        addWait { exp in
            listener = Firestore.firestore()
                .collection("account")
                .document("YusukeHosonuma")
                .addSnapshotListener { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return }
                    
                    callCount += 1

                    switch callCount {
                    case 1:
                        XCTAssertEqual(snapshot.data()?["name"] as? String, "Yusuke Hosonuma")
                        
                    case 2:
                        XCTAssertEqual(snapshot.data()?["name"] as? String, "Tobi")
                        __removeListener()
                        exp.fulfill()

                    default:
                        XCTFail()
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
        defer { waitExpectations() } // ⏳

        let account = AccountDocument(name: "Yusuke Hosonuma")
        
        // ➕ Add
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(account) { (error) in
                XCTAssertNil(error)
            }

        var callCount = 0
        var listener: ListenerRegistration!
        
        func __removeListener() {
            listener.remove() // 🧹 clean-up
        }
        
        // 📌 Listen
        addWait { exp in
            listener = Firestore.firestore()
                .collection("account")
                .document("YusukeHosonuma")
                .addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return }
                    
                    callCount += 1

                    switch callCount {
                    case 1: // initial call
                        XCTAssertEqual(snapshot.data()?["name"] as? String, "Yusuke Hosonuma")

                    case 2: // data or metadata is update
                        break
                        
                    case 3: // data or metadata is update
                        XCTAssertEqual(snapshot.data()?["name"] as? String, "Tobi")
                        __removeListener()
                        exp.fulfill()

                    default:
                        XCTFail()
                    }
                }
        }

        // ▶️ Update
        wait { exp in
            Firestore.root
                .account(id: "YusukeHosonuma")
                .setData(AccountDocument(name: "Tobi")) { (error) in
                    XCTAssertNil(error)
                    exp.fulfill()
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

        var callCount = 0
        
        // 📌 Listen
        let listener = Firestore.firestore()
            .collection("account")
            .document("YusukeHosonuma")
            .addSnapshotListener { (snapshot, error) in
                guard let _ = snapshot else { XCTFail(); return }
                
                callCount += 1
                
                if callCount >= 2 {
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
