//
//  Firestore+CollectionRefBase.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/07.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

open class FirestoreCollectionRefBase<T: FirestoreDocument>: FirestoreCollectionRef {
    public typealias Document = T

    public let ref: CollectionReference

    public var queryRef: Query {
        ref as Query
    }

    public init(_ ref: CollectionReference) {
        self.ref = ref
    }
}
