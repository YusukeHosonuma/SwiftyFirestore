//
//  FirestoreTestCase.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/07.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest

class FirestoreTestCase: XCTestCase {

    var expectations: [XCTestExpectation] = []
    
    override func setUp() {
        FirestoreTestHelper.setupFirebaseApp()
    }

    override func tearDown() {
        FirestoreTestHelper.deleteFirebaseApp()
    }

    func wait(file: StaticString = #file, line: UInt = #line, _ handler: (XCTestExpectation) -> Void) {
        let exp = expectation(description: "\(file) #\(line)")
        handler(exp)
        wait(for: [exp], timeout: 5)
    }
    
    func addWait(file: StaticString = #file, line: UInt = #line, _ handler: (XCTestExpectation) -> Void) {
        let exp = expectation(description: "\(file) #\(line)")
        expectations.append(exp)
        handler(exp)
    }

    func waitExpectations() {
        wait(for: expectations, timeout: 5)
    }
}
