//
//  Firestore+relation.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import SwiftyFirestore

//
// 📄 Data structure
//
// {
//   "todos": <TodoDocument> [],
//   "gist": <GistDocument> []
//   "account": <AccountDocument> [
//     <id>: {
//       "repository: <RepositoryDocument> []
//     }
//   ]
// }
//

extension RootRef {
    var todos:   CollectionRefBase<TodoDocument>    { CollectionRefBase(ref) }
    var gist:    CollectionRefBase<GistDocument>    { CollectionRefBase(ref) }
    var account: CollectionRefBase<AccountDocument> { CollectionRefBase(ref) }
}

extension DocumentRef where Document == AccountDocument {
    var repository: CollectionRefBase<RepositoryDocument> { CollectionRefBase(ref) }
}

extension CollectionGroupRef {
    var repository: CollectionGroupBase<RepositoryDocument> {
        CollectionGroupBase()
    }
}
