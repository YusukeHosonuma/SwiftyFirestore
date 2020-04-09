//
//  Firestore+CollectionRef.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/02/09.
//  Copyright © 2020 Kamui Project. All rights reserved.
//

import FirebaseFirestore

public protocol CollectionRef: QueryRef {
    associatedtype Key = Document.CodingKeys

    var ref: CollectionReference { get }
}

// extension FirestoreCollectionRef {
//    public var queryRef: Query { ref as Query }
// }

extension CollectionRef {
    // MARK: - Rx

//    func asObservable() -> FirestoreCollectionRefRx<Document> {
//        FirestoreCollectionRefRx(ref)
//    }

    // MARK: - Reference

    public func document(_ path: String) -> DocumentRef<Document> {
        DocumentRef(ref: ref.document(path))
    }

    // MARK: - Operator

    public func add(_ document: Document, completion: VoidCompletion? = nil) {
        do {
            ref.addDocument(data: try document.asData(), completion: completion)
        } catch {
            completion?(error)
        }
    }

    // TODO: delete?
    public func getBy(id: String) -> DocumentReference {
        ref.document(id)
    }
}
