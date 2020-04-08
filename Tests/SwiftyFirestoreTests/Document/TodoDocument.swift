//
//  TodoDocument.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import SwiftyFirestore

struct TodoDocument: FirestoreDocument, Equatable {
    static let collectionId: String = "todos"
    
    var documentId: String!
    var title: String
    var done: Bool
    var priority: Int = 0

    enum CodingKeys: String, CodingKey {
        case documentId
        case title
        case done
        case priority
    }
}

struct AccountDocument: FirestoreDocument, Equatable {
    static let collectionId: String = "account"

    var documentId: String!
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case name
    }
}

struct RepositoryDocument: FirestoreDocument, Equatable {
    static let collectionId: String = "repository"

    var documentId: String!
    var name: String
    var language: String // TODO: enum
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case name
        case language
    }
}
