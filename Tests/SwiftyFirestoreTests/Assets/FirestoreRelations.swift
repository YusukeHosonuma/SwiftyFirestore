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
    var todos:   CollectionRef<TodoDocument>    { CollectionRef(ref) }
    var gist:    CollectionRef<GistDocument>    { CollectionRef(ref) }
    var account: CollectionRef<AccountDocument> { CollectionRef(ref) }
}

extension DocumentRef where Document == AccountDocument {
    var repository: CollectionRef<RepositoryDocument> { CollectionRef(ref) }
}

extension CollectionGroupRef {
    var repository: CollectionGroupBase<RepositoryDocument> {
        CollectionGroupBase()
    }
}
