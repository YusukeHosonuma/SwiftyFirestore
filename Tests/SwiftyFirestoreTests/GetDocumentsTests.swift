//
//  GetDocumentsTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/09.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class GetDocumentsTests: FirestoreTestCase {

    override func setUp() {
        super.setUp()
        
        let account = AccountDocument(name: "Yusuke Hosonuma")
                    
        FirestoreDB
            .collection(\.account)
            .document("YusukeHosonuma")
            .setData(account)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: 🐤
    
    func testSourceSwifty() throws {
        waitUntil { done in
            FirestoreDB
                .collection(\.account)
                .getAll(source: .cache) { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ↩️

                    self.assert(documents: documents)
                    done() // 🔓
                }
        }
    }

    // MARK: 🔥
    
    func testSourceFirestoer() throws {
        waitUntil { done in
            Firestore.firestore()
                .collection("account")
                .getDocuments(source: .cache) { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return } // ↩️
                    
                    let documents = snapshot.documents.compactMap {
                        try? Firestore.Decoder().decode(AccountDocument.self, from: $0.data())
                    }
                    
                    self.assert(documents: documents)
                    done() // 🔓
                }
        }
    }
    
    // MARK: 🔧
    
    func assert(documents: [AccountDocument]) {
        XCTAssertEqual(documents.count, 1)
        XCTAssertEqual(documents.first?.name, "Yusuke Hosonuma")
    }
}
