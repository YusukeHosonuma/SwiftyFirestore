//
//  FirestoreTestCase.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/07.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest

class FirestoreTestCase: XCTestCase {

    override func setUp() {
        FirestoreTestHelper.setupFirebaseApp()
    }

    override func tearDown() {
        FirestoreTestHelper.deleteFirebaseApp()
    }
}
