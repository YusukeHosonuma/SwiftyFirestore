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
    
    // MARK: 🐤
    
    func testSourceSwifty() throws {
        wait { done in
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

    // MARK: 🔥
    
    func testSourceFirestoer() throws {
        wait { done in
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
