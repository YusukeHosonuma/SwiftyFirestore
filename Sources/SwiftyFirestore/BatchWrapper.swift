//
//  BatchWrapper.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/10.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public class BatchWrapper {
    private let batch = Firestore.firestore().batch()

    // MARK: Add

    public func setData<Document: FirestoreDocument>(
        _ document: Document,
        forDocument ref: DocumentRef<Document>
    ) throws {
        batch.setData(try document.asData(), forDocument: ref.ref)
    }

    // MARK: Update

    public func update<Document: FirestoreDocument>(
        _ fields: [UpdateField<Document>],
        forDocument ref: DocumentRef<Document>
    ) {
        // TODO: refactor
        let data = fields.map { $0.keyAndValue() }
        let fields = [String: Any](data) { a, _ in a }

        batch.updateData(fields, forDocument: ref.ref)
    }

    // MARK: Delete

    public func delete<Document: FirestoreDocument>(forDocument ref: DocumentRef<Document>) {
        batch.deleteDocument(ref.ref)
    }

    // MARK: Commit

    public func commit(completion: @escaping (Error?) -> Void) {
        batch.commit(completion: completion)
    }
}
