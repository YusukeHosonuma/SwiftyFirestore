//
//  Firestore+relation.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import SwiftyFirestore
import FirebaseFirestore

//
// Data structure:
//
// - Todo
// - Account
//   - Repository
//

extension RootRef {
    var todos: TodoCollectionRef { TodoCollectionRef(ref) }
    var gist: GistCollectionRef { GistCollectionRef(ref) }

    // TODO: not needed?
    func account(id: String) -> AccountDocumentRef { AccountDocumentRef(ref, id: id) }
}

class TodoCollectionRef: FirestoreCollectionRefBase<TodoDocument> {}
class GistCollectionRef: FirestoreCollectionRefBase<GistDocument> {}

final class AccountDocumentRef: FirestoreDocumentRef<AccountDocument> {
    var repository: RepositoryCollectionRef { RepositoryCollectionRef(ref) }
}

class RepositoryCollectionRef: FirestoreCollectionRefBase<RepositoryDocument> {}

extension CollectionGroupRef {
    var repository: CollectionGroupBase<RepositoryDocument> {
        CollectionGroupBase()
    }
}
