//
//  Firestore+QueryRef.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/02/05.
//  Copyright © 2020 Kamui Project. All rights reserved.
//

import FirebaseFirestore
// import RxSwift

public protocol QueryRef {
    associatedtype Document: FirestoreDocument

    typealias VoidCompletion = ((Error?) -> Void)
    typealias CollectionCompletion = (Result<[Document], Error>) -> Void
    typealias ListenerHandler = (Result<(documents: [Document], snapshot: QuerySnapshotWrapper<Document>), Error>) -> Void

    var queryRef: Query { get }
}

extension QueryRef {
    public typealias Key = Document.CodingKeys

    // MARK: - Rx

//    public func asObservable() -> FirestoreQueryRefRx<Document> {
//        FirestoreQueryRefRx<Document>(queryRef: queryRef)
//    }

    // MARK: - Get

    public func getAll(completion: @escaping CollectionCompletion) {
        getAll(source: .default, completion: completion)
    }

    public func getAll(source: FirestoreSource, completion: @escaping CollectionCompletion) {
        queryRef.getDocuments(source: source) { snapshot, error in
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

    // MARK: - Where

    public func whereBy(_ key: Key, _ op: WhereOperator, _ value: Any) -> QueryWrapper<Document> {
        query.whereBy(FirestoreCriteria(key: key, value: value, op: op))
    }

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

    // `...`
    public func whereBy(_ key: Key, arrayContains value: Any) -> QueryWrapper<Document> {
        whereBy(by: key, .arrayContains, value)
    }

    // MARK: Order

    public func orderBy(_ key: Key, sort: Sort = .ascending) -> QueryWrapper<Document> {
        query.orderBy(key.stringValue, sort: sort)
    }

    // MARK: Limit

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

    // MARK: - Listen

    @discardableResult
    public func listen(includeMetadataChanges: Bool = false, completion: @escaping ListenerHandler) -> ListenerRegistration {
        queryRef.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    do {
                        let documents: [Document] = try snapshot.documents.map {
                            var document = try Document($0)
                            document.documentId = $0.documentID
                            return document
                        }

                        let snapshotWrapper = try QuerySnapshotWrapper<Document>(snapshot: snapshot)

                        let result = (documents, snapshotWrapper)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(FirestoreError.unknown))
                }
            }
        }
    }

    // MARK: - Private

    private var query: QueryWrapper<Document> {
        QueryWrapper(queryRef)
    }

    private func whereBy(by key: Key,
                         _ op: WhereOperator,
                         _ value: Any) -> QueryWrapper<Document> {
        query
            .whereBy(FirestoreCriteria(key: key, value: value, op: op))
    }
}
