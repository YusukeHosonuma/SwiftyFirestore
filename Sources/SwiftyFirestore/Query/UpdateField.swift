//
//  UpdateField.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/09.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public enum UpdateField<Document: FirestoreDocument> {
    public typealias Key = Document.CodingKeys

    case value(Key, Any)
    case increment(Key, Int)
    case arrayUnion(Key, [Any])
    case arrayRemove(Key, [Any])
    case delete(Key)

    func keyAndValue() -> (String, Any) {
        switch self {
        case let .value(key, value):
            return (key.stringValue, value)

        case let .increment(key, value):
            return (key.stringValue, FieldValue.increment(Int64(value)))

        case let .arrayUnion(key, value):
            return (key.stringValue, FieldValue.arrayUnion(value))

        case let .arrayRemove(key, value):
            return (key.stringValue, FieldValue.arrayRemove(value))

        case let .delete(key):
            return (key.stringValue, FieldValue.delete())
        }
    }
}