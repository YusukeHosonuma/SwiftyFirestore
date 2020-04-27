//
//  DocumentRefProtocol.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/27.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public protocol DocumentRefProtocol {
    associatedtype Document: FirestoreDocument

    typealias Key = Document.CodingKeys
    typealias DocumentCompletion = (Result<Document?, Error>) -> Void
    typealias VoidCompletion = ((Error?) -> Void)

    // TODO: change `metadata` to `snapshot`
    typealias ListenerHandler = (Result<(document: Document?, metadata: SnapshotMetadata), Error>) -> Void

    var ref: DocumentReference { get }
}
