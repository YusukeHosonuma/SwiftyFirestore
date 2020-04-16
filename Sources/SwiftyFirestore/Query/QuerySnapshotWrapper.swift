//
//  QuerySnapshotWrapper.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/10.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public struct QuerySnapshotWrapper<Document: FirestoreDocument> {
    public var metadata: SnapshotMetadata
    public var documentChanges: [DocumentChangeWrapper<Document>]

    init(snapshot: QuerySnapshot) throws {
        metadata = snapshot.metadata
        documentChanges = try snapshot.documentChanges.map {
            DocumentChangeWrapper(type: $0.type, document: try Document($0.document))
        }
    }
}
