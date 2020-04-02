//
//  Firestore+relation.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import SwiftyFirestore

extension RootRef {
    var todos: TodoCollectionRef {
        TodoCollectionRef(ref.collection("todos"))
    }
}
