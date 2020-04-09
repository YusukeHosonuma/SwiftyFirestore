//
//  UpdateField.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/09.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public enum UpdateField<Document: FirestoreDocument> {
    case value(Document.CodingKeys, Any)
    case increment(Document.CodingKeys, Int)
    case arrayUnion(Document.CodingKeys, [Any])
    case arrayRemove(Document.CodingKeys, [Any])
    case delete(Document.CodingKeys)

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
