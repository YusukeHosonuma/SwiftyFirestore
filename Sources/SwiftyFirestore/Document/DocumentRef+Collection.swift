//
//  DocumentRef+Collection.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/27.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

extension DocumentRefProtocol {
    // MARK: - Rx

//    func asObservable() -> FirestoreDocumentRefRx<Document> {
//        FirestoreDocumentRefRx<Document>(ref)
//    }

    // MARK: Reference

    public func collection<To: FirestoreDocument>(_: KeyPath<Document.Has, To.Type>) -> CollectionRef<To> where Document: HasCollection {
        CollectionRef(ref)
    }
}
