//
//  CollectionGroupBase.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/08.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public final class CollectionGroupRef<Document: FirestoreDocument>: QueryRef {
    public let queryRef: Query

    public init() {
        queryRef = Firestore.firestore().collectionGroup(Document.collectionID)
    }
}
