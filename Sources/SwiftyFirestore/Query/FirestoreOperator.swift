//
//  FirestoreOperator.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/09.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

public enum WhereOperator: String, ExpressibleByStringLiteral {
    case isEqualTo = "=="
    case isLessThan = "<"
    case isLessThanOrEqualTo = "<="
    case isGreaterThan = ">"
    case isGreaterThanOrEqualTo = ">="
    case arrayContains = "..."

    public init(stringLiteral value: String) {
        self = WhereOperator(rawValue: value)! // Logical error when given not supported operator
    }
}
