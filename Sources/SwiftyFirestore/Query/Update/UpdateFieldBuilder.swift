//
//  UpdateFieldBuilder.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/18.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public final class UpdateFieldBuilder<Document: FirestoreDocument> {
    public typealias Key = Document.CodingKeys

    private var fields: [UpdateField] = []

    // MARK: Public

    public func update<T: Any>(_ key: Key, path _: KeyPath<Document, T>, _ value: T) {
        fields.append(Field(key.stringValue, value))
    }

    public func update<T: FirestoreData>(_ key: Key, path _: KeyPath<Document, T>, _ value: T) {
        fields.append(UpdateData(key: key.stringValue, value: value))
    }

    public func update<T: FirestoreData>(_ key: Key, path _: KeyPath<Document, T?>, _ value: T) {
        fields.append(UpdateData(key: key.stringValue, value: value))
    }

    public func update<T: FirestoreEnum>(_ key: Key, path _: KeyPath<Document, T>, _ value: T) {
        fields.append(Field(key.stringValue, value.rawValue))
    }

    public func update<T: FirestoreEnum>(_ key: Key, path _: KeyPath<Document, T?>, _ value: T) {
        fields.append(Field(key.stringValue, value.rawValue))
    }

    public func increment(_ key: Key, path _: KeyPath<Document, Int>, _ value: Int) {
        let key = key.stringValue
        let value = FieldValue.increment(Int64(value))
        fields.append(Field(key, value))
    }

    public func arrayUnion<T: Any>(_ key: Key, path _: KeyPath<Document, [T]>, _ value: [T]) {
        let key = key.stringValue
        let value = FieldValue.arrayUnion(value)
        fields.append(Field(key, value))
    }

    public func arrayRemove<T: Any>(_ key: Key, path _: KeyPath<Document, [T]>, _ value: [T]) {
        let key = key.stringValue
        let value = FieldValue.arrayRemove(value)
        fields.append(Field(key, value))
    }

    public func delete(_ key: Key) {
        let key = key.stringValue
        let value = FieldValue.delete()
        fields.append(Field(key, value))
    }

    public func serverTimestamp(_ key: Key) {
        let key = key.stringValue
        let value = FieldValue.serverTimestamp()
        fields.append(Field(key, value))
    }

    public func nestedValue<T: Any>(_ nestedPath: String, _ value: T) {
        fields.append(Field(nestedPath, value))
    }

    // MARK: Internal

    func build() throws -> [String: Any] {
        let array = try fields.map { try $0.keyAndValue() }
        return [String: Any](array) { a, _ in a }
    }
}

private struct Field: UpdateField {
    var key: String
    var value: Any

    init(_ key: String, _ value: Any) {
        self.key = key
        self.value = value
    }

    func keyAndValue() throws -> (String, Any) {
        return (key, value)
    }
}
