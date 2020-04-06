//
//  Firestore+relation.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import SwiftyFirestore
import FirebaseFirestore

extension RootRef {
    var todos: TodoCollectionRef {
        TodoCollectionRef(ref.collection("todos"))
    }
}

extension RootRef {
    func account(id: String) -> AccountDocumentRef {
        AccountDocumentRef(ref.collection("account").document(id))
    }
}

extension AccountDocumentRef {
    var repository: RepositoryCollectionRef {
        RepositoryCollectionRef(ref.collection("repository"))
    }
}

class AccountDocumentRef: FirestoreDocumentRef<AccountDocument> {}

class RepositoryCollectionRef: FirestoreCollectionRef {
    typealias Document = RepositoryDocument

    let ref: CollectionReference

    init(_ ref: CollectionReference) {
        self.ref = ref
    }
}
