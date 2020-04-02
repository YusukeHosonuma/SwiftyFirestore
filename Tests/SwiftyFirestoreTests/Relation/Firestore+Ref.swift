//
//  Firestore+Ref.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore
import SwiftyFirestore

class TodoCollectionRef: FirestoreCollectionRef {
    typealias Document = TodoDocument

    let ref: CollectionReference

    init(_ ref: CollectionReference) {
        self.ref = ref
    }
}

