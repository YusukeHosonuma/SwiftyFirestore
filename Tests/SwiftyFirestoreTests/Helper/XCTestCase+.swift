//
//  XCTestCase+.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/10.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func wait(time: Double, file: StaticString = #file, line: UInt = #line) {
        waitUntil { done in
            DispatchQueue.global().asyncAfter(deadline: .now() + time) {
                done() // 🔓
            }
        }
    }

    func waitUntil(
        timeout: Double = 10.0,
        file: StaticString = #file,
        line: UInt = #line, _
        handler: (@escaping () -> Void) -> Void
    ) {
        let exp = expectation(description: "\(file) #\(line)")
        handler { exp.fulfill() }
        
        let result = XCTWaiter.wait(for: [exp], timeout: timeout) // ⏳
        
        switch result {
        case .completed:
            break
            
        case .timedOut:
            XCTFail("Expectation is timeout \(timeout)s.", file: file, line: line)

        case .incorrectOrder:
            XCTFail("Expectation is incorrect order.", file: file, line: line)

        case .invertedFulfillment:
            XCTFail("Expectation is inverted fullfillment.", file: file, line: line)

        case .interrupted:
            XCTFail("Expectation is interupted.", file: file, line: line)

        @unknown default:
            XCTFail("Expectation is timeout.", file: file, line: line)
        }
    }
    
    func wait(
        queue: inout [XCTestExpectation],
        file: StaticString = #file,
        line: UInt = #line,
        _ handler: (XCTestExpectation) -> Void
    ) {
        let exp = expectation(description: "\(file) #\(line)")
        queue.append(exp)
        handler(exp)
    }
}
