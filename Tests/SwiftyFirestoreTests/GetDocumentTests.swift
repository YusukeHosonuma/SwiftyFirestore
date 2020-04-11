//
//  GetDocumentTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/09.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class GetDocumentTests: FirestoreTestCase {

    override func setUp() {
        super.setUp()
        
        let account = AccountDocument(name: "Yusuke Hosonuma")
        
        Firestore.root
            .account
            .document("YusukeHosonuma")
            .setData(account)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Exists
    
    func testExsitsSwifty() throws {
        // ✅ Exists - Traditional
        waitUntil { done in
            Firestore.root
                .account
                .document("YusukeHosonuma")
                .get { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️

                    XCTAssertNotNil(document)
                    done()
                }
        }

        // ✅ Exists - Extended (more expressive)
        waitUntil { done in
            Firestore.root
                .account
                .document("YusukeHosonuma")
                .exists { result in
                    guard case .success(let exists) = result else { XCTFail(); return } // ↩️

                    XCTAssertTrue(exists)
                    done()
                }
        }
        
        // ☑️ Not Exists
        waitUntil { done in
            Firestore.root
                .account
                .document("NoName")
                .get { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️

                    XCTAssertNil(document)
                    done()
                }
        }
    }
    
    // MARK: 🔥 Firestore
    
    func testExistsFirestore() throws {
        // ✅ Exists
        waitUntil { done in
            Firestore.firestore()
                .collection("account")
                .document("YusukeHosonuma")
                .getDocument { (snapshot, error) in
                    XCTAssertEqual(snapshot?.exists, true)
                    done()
                }
        }

        // ☑️ Not Exists
        waitUntil { done in
            Firestore.firestore()
                .collection("account")
                .document("NoName")
                .getDocument { (snapshot, error) in
                    XCTAssertEqual(snapshot?.exists, false)
                    done()
                }
        }
    }
    
    // MARK: - Source
    
    // MARK: 🐤 Swifty
    
    func testSourceSwifty() throws {
        waitUntil { done in
            Firestore.root
                .account
                .document("YusukeHosonuma")
                .get(source: .cache) { result in
                    guard case .success(let document) = result else { XCTFail(); return } // ↩️

                    self.assert(document: document)
                    done()
                }
        }
    }

    // MARK: 🔥 Firestore
    
    func testSourceFirestoer() throws {
        waitUntil { done in
            Firestore.firestore()
                .collection("account")
                .document("YusukeHosonuma")
                .getDocument(source: .cache) { (snapshot, error) in
                    guard
                        let snapshot = snapshot,
                        let data = snapshot.data(),
                        let document = try? Firestore.Decoder().decode(AccountDocument.self, from: data) else { XCTFail(); return } // ↩️

                    self.assert(document: document)
                    done() // 🔓
                }
        }
    }
    
    // MARK: 🔧
    
    func assert(document: AccountDocument?) {
        XCTAssertEqual(document?.name, "Yusuke Hosonuma")
    }
}
