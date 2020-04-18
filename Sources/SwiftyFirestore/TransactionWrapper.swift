//
//  TransactionWrapper.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/10.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public class TransactionWrapper {
    let transaction: Transaction

    init(_ transaction: Transaction) {
        self.transaction = transaction
    }

    public func get<Document: FirestoreDocument>(_ ref: DocumentRef<Document>) throws -> Document? {
        let documentSnapshot = try transaction.getDocument(ref.ref)
        let document = try documentSnapshot.data(as: Document.self)
        return document
    }

    public func update<Document: FirestoreDocument>(
        for ref: DocumentRef<Document>,
        fields: (UpdateFieldBuilder<Document>) -> Void
    ) throws {
        let builder = UpdateFieldBuilder<Document>()
        fields(builder)

        let fields = try builder.build()
        let data = [String: Any](fields) { a, _ in a }
        transaction.updateData(data, forDocument: ref.ref)
    }
}
