//
//  UpdateField.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/09.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

// TODO: tests
public enum UpdateField<Document: FirestoreDocument> {
    public typealias Key = Document.CodingKeys

    case value(Key, Any)
    case increment(Key, Int)
    case arrayUnion(Key, [Any])
    case arrayRemove(Key, [Any])
    case delete(Key)
    case serverTimestamp(Key)
    case nestedValue(Key, path: String, Any)

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

        case let .serverTimestamp(key):
            return (key.stringValue, FieldValue.serverTimestamp())

        case let .nestedValue(key, path: path, value):
            return (key.stringValue + "." + path, value)
        }
    }

    static func asDicrionary(_ fields: [UpdateField]) -> [String: Any] {
        let data = fields.map { $0.keyAndValue() }
        return [String: Any](data) { a, _ in a }
    }
}
