//
//  Firestore+DocumentRef.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/02/13.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

public class DocumentRef<Document: FirestoreDocument>: Codable {
    public typealias Key = Document.CodingKeys

    public typealias VoidCompletion = ((Error?) -> Void)
    public typealias DocumentCompletion = (Result<Document?, Error>) -> Void
    // TODO: change `metadata` to `snapshot`
    public typealias ListenerHandler = (Result<(document: Document?, metadata: SnapshotMetadata), Error>) -> Void

    public let ref: DocumentReference

//    public init(_ ref: DocumentReference) {
//        self.ref = ref
//    }

    public init(_ ref: Firestore, id: String) {
        self.ref = ref.collection(Document.collectionID).document(id)
    }

    public init(ref: DocumentReference) {
        self.ref = ref
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ref = try values.decode(DocumentReference.self, forKey: .ref)
    }
}

extension DocumentRef: Equatable {
    public static func == (lhs: DocumentRef<Document>, rhs: DocumentRef<Document>) -> Bool {
        lhs.ref == rhs.ref
    }
}

extension DocumentRef {
    // MARK: - Rx

//    func asObservable() -> FirestoreDocumentRefRx<Document> {
//        FirestoreDocumentRefRx<Document>(ref)
//    }

    // MARK: Reference

    public func collection<To: FirestoreDocument>(_: KeyPath<Document, To.Type>) -> CollectionRef<To> {
        CollectionRef(ref)
    }
}
