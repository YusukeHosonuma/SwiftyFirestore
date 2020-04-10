//
//  DocumentChangeWrapper.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/10.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public struct DocumentChangeWrapper<Document: FirestoreDocument> {
    var type: DocumentChangeType
    var document: Document
    // TODO: more...
}
