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

public class CollectionGroupRef {}

extension Firestore {
    public static var root: RootRef {
        RootRef(Firestore.firestore())
    }

    public static var collectionGroup: CollectionGroupRef {
        CollectionGroupRef()
    }
}
