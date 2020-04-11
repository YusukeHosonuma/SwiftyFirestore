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
    var account: AccountCollectionRef { AccountCollectionRef(ref) }
}

class TodoCollectionRef: CollectionRefBase<TodoDocument> {}
class GistCollectionRef: CollectionRefBase<GistDocument> {}
class AccountCollectionRef: CollectionRefBase<AccountDocument> {}

class RepositoryCollectionRef: CollectionRefBase<RepositoryDocument> {}

extension CollectionGroupRef {
    var repository: CollectionGroupBase<RepositoryDocument> {
        CollectionGroupBase()
    }
}

extension DocumentRef where Document == AccountDocument {
    var repository: RepositoryCollectionRef { RepositoryCollectionRef(ref) }
}
