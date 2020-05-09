//
//  TodoDocument.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import SwiftyFirestore
import FirebaseFirestore

//
// 📄 Data structure
//
// {
//     todos: <TodoDocument> [],
//     gist: <GistDocument> [],
//     account: <AccountDocument> [
//         <id>: {
//             repository: <RepositoryDocument> []
//         }
//     ]
// }
//

// MARK: - Relations

extension Root {
    var todos: TodoDocument.Type { TodoDocument.self }
    var account: AccountDocument.Type { AccountDocument.self }
    var gist: GistDocument.Type { GistDocument.self }
}

extension AccountDocument: HasCollection {
    class Has {
        var repository = RepositoryDocument.self
    }
}

// MARK: CollectionGroups

extension CollectionGroups {
    var repository: RepositoryDocument.Type { RepositoryDocument.self }
}

// MARK: - Documents

struct TodoDocument: FirestoreDocument, Equatable {
    static let collectionID: String = "todos"

    struct Info: FirestoreData, Equatable {
        var color: String
        var size: Int
    }
    
    enum Color: String, FirestoreEnum {
        case red
        case blue
    }
    
    var documentID: String!
    var documentReference: DocumentRef<TodoDocument>!
    
    var title: String
    var done: Bool
    var priority: Int = 0
    var tags: [String] = []
    var remarks: String?
    var lastUpdated: Timestamp?
    var info: Info?
    var color: Color = .red

    typealias Keys = CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case title
        case done
        case priority
        case tags
        case remarks
        case lastUpdated
        case info
        case color
        var title: CodingKeys { .title }
    }
}

struct AccountDocument: FirestoreDocument, Equatable {
    static let collectionID: String = "account"

    var documentID: String!
    var documentReference: DocumentRef<AccountDocument>!
    
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case documentID
        case name
    }
}

struct RepositoryDocument: FirestoreDocument, Equatable {
    static let collectionID: String = "repository"

    var documentID: String!
    var documentReference: DocumentRef<RepositoryDocument>!
    
    var name: String
    var language: String // TODO: enum
    
    enum CodingKeys: String, CodingKey {
        case documentID
        case name
        case language
    }
}

struct GistDocument: FirestoreDocument {
    static let collectionID: String = "gist"

    var documentID: String!
    var documentReference: DocumentRef<GistDocument>!
    
    var url: String
    var account: DocumentRef<AccountDocument>
    
    enum CodingKeys: String, CodingKey {
        case documentID
        case url
        case account
    }
}
