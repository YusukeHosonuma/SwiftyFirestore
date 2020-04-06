//
//  Firestore+QueryRef.swift
//  Raito
//
//  Created by Yusuke Hosonuma on 2020/02/05.
//  Copyright © 2020 Kamui Project. All rights reserved.
//

import FirebaseFirestore
// import RxSwift

public protocol FirestoreQueryRef {
    associatedtype Document: FirestoreDocument

    typealias VoidCompletion = ((Error?) -> Void)
    typealias CollectionCompletion = (Result<[Document], Error>) -> Void

    var queryRef: Query { get }
}

extension FirestoreQueryRef {
    public typealias Key = Document.CodingKeys

    // MARK: - Rx

//    public func asObservable() -> FirestoreQueryRefRx<Document> {
//        FirestoreQueryRefRx<Document>(queryRef: queryRef)
//    }

    // MARK: - Operaator

    public func getAll(completion: @escaping CollectionCompletion) {
        queryRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    do {
                        completion(.success(try snapshot.documents.map(Document.init)))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(FirestoreError.unknown))
                }
            }
        }
    }

    public func whereBy(_ key: Key, _ op: FirestoreOperator, _ value: Any) -> QueryWrapper<Document> {
        query.whereBy(FirestoreCriteria(key: key, value: value, op: op))
    }

    // TODO: ↑ の API で十分な気はするので、以下は削除することも検討

    // `==`
    public func whereBy(_ key: Key, isEqualTo value: Any) -> QueryWrapper<Document> {
        whereBy(by: key, .isEqualTo, value)
    }

    // `<`
    public func whereBy(_ key: Key, isLessThan value: Any) -> QueryWrapper<Document> {
        whereBy(by: key, .isLessThan, value)
    }

    // `<=`
    public func whereBy(_ key: Key, isLessThanOrEqualTo value: Any) -> QueryWrapper<Document> {
        whereBy(by: key, .isLessThanOrEqualTo, value)
    }

    // `>`
    public func whereBy(_ key: Key, isGreaterThan value: Any) -> QueryWrapper<Document> {
        whereBy(by: key, .isGreaterThan, value)
    }

    // `>=`
    public func whereBy(_ key: Key, isGreaterThanOrEqualTo value: Any) -> QueryWrapper<Document> {
        whereBy(by: key, .isGreaterThanOrEqualTo, value)
    }

    public func orderBy(_ key: Key, sort: FirestoreSort = .ascending) -> QueryWrapper<Document> {
        query.orderBy(key.stringValue, sort: sort)
    }

    // TODO: should more swifty API or not...

    public func limitTo(_ limit: Int) -> QueryWrapper<Document> {
        query.limitTo(limit)
    }

    public func limitToLast(_ limit: Int) -> QueryWrapper<Document> {
        query.limitToLast(limit)
    }

    // `{start} <= value && value <= {end}`
    public func between<T: Any>(_ key: Key, _ start: T, _ end: T) -> QueryWrapper<Document> {
        whereBy(key, isGreaterThanOrEqualTo: start).whereBy(key, isLessThanOrEqualTo: end)
    }

    // MARK: - Private

    private var query: QueryWrapper<Document> {
        QueryWrapper(queryRef)
    }

    private func whereBy(by key: Key,
                         _ op: FirestoreOperator,
                         _ value: Any) -> QueryWrapper<Document> {
        query
            .whereBy(FirestoreCriteria(key: key, value: value, op: op))
    }
}
