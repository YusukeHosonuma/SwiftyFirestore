//
//  Firestore+Criteria.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/02/05.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public class QueryWrapper<Document: FirestoreDocument>: QueryRef {
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
        case .arrayContains:
            return QueryWrapper(queryRef.whereField(field, arrayContains: value))
        }
    }

    public func orderBy(_ key: String, sort: Sort) -> QueryWrapper {
        QueryWrapper(queryRef.order(by: key, descending: sort == .descending))
    }

    public func limitTo(_ limit: Int) -> QueryWrapper {
        QueryWrapper(queryRef.limit(to: limit))
    }

    public func limitToLast(_ limit: Int) -> QueryWrapper {
        QueryWrapper(queryRef.limit(toLast: limit))
    }
}
