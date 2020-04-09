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

    // TODO: not needed?
    func account(id: String) -> AccountDocumentRef { AccountDocumentRef(ref, id: id) }
}

class TodoCollectionRef: CollectionRefBase<TodoDocument> {}
class GistCollectionRef: CollectionRefBase<GistDocument> {}
class AccountCollectionRef: CollectionRefBase<AccountDocument> {}

final class AccountDocumentRef: DocumentRef<AccountDocument> {
    var repository: RepositoryCollectionRef { RepositoryCollectionRef(ref) }
}

class RepositoryCollectionRef: CollectionRefBase<RepositoryDocument> {}

extension CollectionGroupRef {
    var repository: CollectionGroupBase<RepositoryDocument> {
        CollectionGroupBase()
    }
}
