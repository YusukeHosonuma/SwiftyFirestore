//
//  CollectionGroupBase.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/08.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

open class CollectionGroupBase<T: FirestoreDocument>: FirestoreQueryRef {
    public let queryRef: Query

    public typealias Document = T

    public init() {
        queryRef = Firestore.firestore().collectionGroup(T.collectionId)
    }
}
