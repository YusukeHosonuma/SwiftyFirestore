//
//  Firestore+CollectionRefBase.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/07.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

open class FirestoreCollectionRefBase<T: FirestoreDocument>: FirestoreCollectionRef {
    public var ref: CollectionReference

    public typealias Document = T

    public var queryRef: Query {
        ref as Query
    }

    public init(_ ref: Firestore) {
        self.ref = ref.collection(T.collectionId)
    }

    public init(_ ref: DocumentReference) {
        self.ref = ref.collection(T.collectionId)
    }
}
