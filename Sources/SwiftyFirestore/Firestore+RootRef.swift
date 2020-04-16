//
//  Firestore+RootRef.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public class Root {}
public class CollectionGroups {}

public class FirestoreDB {
    private init() {}

    public static func collection<To: FirestoreDocument>(_: KeyPath<Root, To.Type>) -> CollectionRef<To> {
        CollectionRef(Firestore.firestore())
    }

    public static func collectionGroup<To: FirestoreDocument>(_: KeyPath<CollectionGroups, To.Type>) -> CollectionGroupRef<To> {
        CollectionGroupRef<To>(Firestore.firestore())
    }
}

extension FirestoreDB {
    public static func runTransaction<Return>(
        _ updateBlock: @escaping (TransactionWrapper, NSErrorPointer) -> Return?,
        completion: @escaping (Result<Return, Error>) -> Void
    ) {
        Firestore.firestore()
            .runTransaction({ (transaction, errorPointer) -> Any? in
                updateBlock(TransactionWrapper(transaction), errorPointer)
            }, completion: { object, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    if let object = object as? Return {
                        completion(.success(object))
                    } else {
                        preconditionFailure("unknown error")
                    }
                }
            })
    }

    public static func batch() -> BatchWrapper {
        BatchWrapper()
    }
}
