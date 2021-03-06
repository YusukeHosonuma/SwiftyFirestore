//
//  Firestore+DocumentRef.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/02/13.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public class DocumentRef<Document: FirestoreDocument>: DocumentRefProtocol, Codable {
    public let ref: DocumentReference

    public init(_ ref: Firestore, id: String) {
        self.ref = ref.collection(Document.collectionID).document(id)
    }

    public init(ref: DocumentReference) {
        self.ref = ref
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer()
        ref = try values.decode(DocumentReference.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(ref)
    }
}

extension DocumentRef: Equatable {
    public static func == (lhs: DocumentRef<Document>, rhs: DocumentRef<Document>) -> Bool {
        lhs.ref == rhs.ref
    }
}
