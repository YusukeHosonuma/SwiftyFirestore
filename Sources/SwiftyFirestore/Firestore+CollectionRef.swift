//
//  Firestore+CollectionRef.swift
//  Raito
//
//  Created by Yusuke Hosonuma on 2020/02/09.
//  Copyright © 2020 Kamui Project. All rights reserved.
//

import FirebaseFirestore

public protocol FirestoreCollectionRef: FirestoreQueryRef {
    associatedtype Key = Document.CodingKeys

    var ref: CollectionReference { get }
}

extension FirestoreCollectionRef {
    public var queryRef: Query { ref as Query }
}

extension FirestoreCollectionRef {
    // MARK: - Rx

//    func asObservable() -> FirestoreCollectionRefRx<Document> {
//        FirestoreCollectionRefRx(ref)
//    }

    // MARK: - Reference

    public func document(_ path: String) -> FirestoreDocumentRef<Document> {
        FirestoreDocumentRef(ref.document(path))
    }

    // MARK: - Operator

    public func add(_ document: Document, completion: VoidCompletion? = nil) {
        do {
            ref.addDocument(data: try document.asData(), completion: completion)
        } catch {
            completion?(error)
        }
    }

    public func getBy(id: String) -> DocumentReference {
        ref.document(id)
    }
}
