//
//  Firestore+relation.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import SwiftyFirestore
import FirebaseFirestore

// MARK: - Ref

class TodoCollectionRef: FirestoreCollectionRefBase<TodoDocument> {}
class AccountDocumentRef: FirestoreDocumentRef<AccountDocument> {}
class RepositoryCollectionRef: FirestoreCollectionRefBase<RepositoryDocument> {}

// MARK: - Relation

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
