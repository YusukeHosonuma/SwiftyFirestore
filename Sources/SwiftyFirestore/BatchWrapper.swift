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
        ref: DocumentRef<Document>,
        _ document: Document
    ) throws {
        batch.setData(try document.asData(), forDocument: ref.ref)
    }

    // MARK: Update

    public func update<Document: FirestoreDocument>(
        ref: DocumentRef<Document>,
        _ fields: [UpdateField<Document>]
    ) {
        let fields = UpdateField.asDicrionary(fields)
        batch.updateData(fields, forDocument: ref.ref)
    }

    // MARK: Delete

    public func delete<Document: FirestoreDocument>(ref: DocumentRef<Document>) {
        batch.deleteDocument(ref.ref)
    }

    // MARK: Commit

    public func commit() {
        batch.commit()
    }

    public func commit(completion: @escaping (Error?) -> Void) {
        batch.commit(completion: completion)
    }
}
