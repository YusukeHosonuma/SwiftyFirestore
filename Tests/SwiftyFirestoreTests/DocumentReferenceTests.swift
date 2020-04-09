//
//  DocumentReferenceTests.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/08.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest
@testable import SwiftyFirestore
import FirebaseFirestore

class DocumentReferenceTests: FirestoreTestCase {

    override func setUp() {
        super.setUp()
        
        // Data:
        //
        // {
        //   "account": <AccountDocument> [
        //     "YusukeHosonuma" {
        //       name: "Yusuke Hosonuma"
        //     }
        //   ]
        //   "gist": <GistDocument> [
        //     url: "https://gist.github.com/YusukeHosonuma/1",
        //     account: <ref: /account/YusukeHosonuma>
        //   ]
        // }
        //
        
        Firestore.root
            .account(id: "YusukeHosonuma")
            .setData(AccountDocument(name: "Yusuke Hosonuma")) { error in
                XCTAssertNil(error)
            }
        
        let accountRef = AccountDocumentRef(ref: Firestore.root.account(id: "YusukeHosonuma").ref)
        
        Firestore.root
            .gist
            .add(GistDocument(url: "https://gist.github.com/YusukeHosonuma/1", account: accountRef))
    }

    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Swifty 🐤
    
    func testSwifty() {
        wait { done in
            Firestore.root
                .gist
                .getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return } // ✅
                    
                    documents[0].account.get { result in
                        guard case .success(let account) = result else { XCTFail(); return } // ✅
                        
                        self.assert(account: account)
                        done() // 🔓
                    }
                }
        }
    }

    // MARK: - Firestore 🔥
    
    func testFirestore() {
        wait { done in
            Firestore.firestore()
                .collection("gist")
                .getDocuments { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return } // ✅
                    
                    let documents = snapshot.documents.compactMap {
                        try? Firestore.Decoder().decode(GistDocument.self, from: $0.data())
                    }
                    
                    documents[0].account.ref.getDocument { (snapshot, error) in
                        guard let snapshot = snapshot, let data = snapshot.data() else { XCTFail(); return } // ✅
                        
                        let account = try? Firestore.Decoder().decode(AccountDocument.self, from: data)

                        self.assert(account: account)
                        done() // 🔓
                    }
                }
        }
    }
    
    // MARK: - Helper
    
    func assert(account: AccountDocument?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(account?.name, "Yusuke Hosonuma", file: file, line: line)
    }
}
