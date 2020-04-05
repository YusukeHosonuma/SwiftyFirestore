//
//  TodoDocument.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import SwiftyFirestore

struct TodoDocument: FirestoreDocument, Equatable {
    var documentId: String!
    var title: String
    var done: Bool

    enum CodingKeys: String, CodingKey {
        case documentId
        case title
        case done
    }
}
