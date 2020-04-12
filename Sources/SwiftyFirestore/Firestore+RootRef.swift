//
//  Firestore+RootRef.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public class RootRef {
    public let ref: Firestore

    public init(_ firestore: Firestore) {
        ref = firestore
    }
}

public class CollectionGroups {}

extension Firestore {
    public static var root: RootRef {
        RootRef(Firestore.firestore())
    }

    public static var collectionGroup: CollectionGroups {
        CollectionGroups()
    }

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
