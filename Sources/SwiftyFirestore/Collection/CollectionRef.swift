//
//  Firestore+CollectionRefBase.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/07.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public class CollectionRef<Document: FirestoreDocument>: QueryRef {
    public var ref: CollectionReference

    public var queryRef: Query {
        ref as Query
    }

    public init(_ ref: Firestore) {
        self.ref = ref.collection(Document.collectionID)
    }

    public init(_ ref: DocumentReference) {
        self.ref = ref.collection(Document.collectionID)
    }
}

extension CollectionRef {
    // MARK: 📄 Document

    // TODO: test
    public func document() -> DocumentRef<Document> {
        DocumentRef(ref: ref.document())
    }

    public func document(_ path: String) -> DocumentRef<Document> {
        DocumentRef(ref: ref.document(path))
    }

    // MARK: ➕ Add

    @discardableResult
    public func add(_ document: Document, completion: VoidCompletion? = nil) throws -> DocumentRef<Document> {
        let documentRef = ref.addDocument(data: try document.asData(), completion: completion)
        return DocumentRef(ref: documentRef)
    }
}
