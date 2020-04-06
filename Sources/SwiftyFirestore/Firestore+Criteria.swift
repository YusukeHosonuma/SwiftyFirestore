//
//  Firestore+Criteria.swift
//  Raito
//
//  Created by Yusuke Hosonuma on 2020/02/05.
//  Copyright © 2020 Kamui Project. All rights reserved.
//
import FirebaseFirestore

public enum FirestoreSort {
    case ascending
    case descending
}

public enum FirestoreOperator: String, ExpressibleByStringLiteral {
    case isEqualTo = "=="
    case isLessThan = "<"
    case isLessThanOrEqualTo = "<="
    case isGreaterThan = ">"
    case isGreaterThanOrEqualTo = ">="

    public init(stringLiteral value: String) {
        self = FirestoreOperator(rawValue: value)! // Logical error when given not supported operator
    }
}

public struct FirestoreCriteria<T: FirestoreDocument> {
    public var key: T.CodingKeys
    public var value: Any
    public var op: FirestoreOperator
}

public class QueryWrapper<Document: FirestoreDocument>: FirestoreQueryRef {
    public let queryRef: Query

    public init(_ query: Query) {
        queryRef = query
    }

    public func whereBy(_ criteria: FirestoreCriteria<Document>) -> QueryWrapper {
        let field = criteria.key.stringValue
        let value = criteria.value

        switch criteria.op {
        case .isEqualTo:
            return QueryWrapper(queryRef.whereField(field, isEqualTo: value))
        case .isLessThan:
            return QueryWrapper(queryRef.whereField(field, isLessThan: value))
        case .isLessThanOrEqualTo:
            return QueryWrapper(queryRef.whereField(field, isLessThanOrEqualTo: value))
        case .isGreaterThan:
            return QueryWrapper(queryRef.whereField(field, isGreaterThan: value))
        case .isGreaterThanOrEqualTo:
            return QueryWrapper(queryRef.whereField(field, isGreaterThanOrEqualTo: value))
        }
    }

    public func orderBy(_ key: String, sort: FirestoreSort) -> QueryWrapper {
        QueryWrapper(queryRef.order(by: key, descending: sort == .descending))
    }
}
