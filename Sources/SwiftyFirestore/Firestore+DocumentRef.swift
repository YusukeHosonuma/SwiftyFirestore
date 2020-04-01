//
//  Firestore+DocumentRef.swift
//  Raito
//
//  Created by Yusuke Hosonuma on 2020/02/13.
//  Copyright © 2020 Kamui Project. All rights reserved.
//

import FirebaseFirestore

public class FirestoreDocumentRef<Document: FirestoreDocument> {
    public typealias VoidCompletion = ((Error?) -> Void)

    let ref: DocumentReference

    public init(_ ref: DocumentReference) {
        self.ref = ref
    }
}

extension FirestoreDocumentRef {
    // MARK: - Rx

//    func asObservable() -> FirestoreDocumentRefRx<Document> {
//        FirestoreDocumentRefRx<Document>(ref)
//    }

    // MARK: - Operator

    public func delete(completion: VoidCompletion?) {
        ref.delete(completion: completion)
    }

    public func setData(_ document: Document, completion: VoidCompletion?) {
        do {
            ref.setData(try document.asData(), completion: completion)
        } catch {
            completion?(error)
        }
    }
}
