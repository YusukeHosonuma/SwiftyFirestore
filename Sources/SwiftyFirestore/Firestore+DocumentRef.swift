//
//  Firestore+DocumentRef.swift
//  Raito
//
//  Created by Yusuke Hosonuma on 2020/02/13.
//  Copyright © 2020 Kamui Project. All rights reserved.
//

import FirebaseFirestore

open class FirestoreDocumentRef<Document: FirestoreDocument>: Codable {
    public typealias VoidCompletion = ((Error?) -> Void)
    public typealias DocumentCompletion = (Result<Document?, Error>) -> Void

    public let ref: DocumentReference

//    public init(_ ref: DocumentReference) {
//        self.ref = ref
//    }

    public init(_ ref: Firestore, id: String) {
        self.ref = ref.collection(Document.collectionId).document(id)
    }

    public init(ref: DocumentReference) {
        self.ref = ref
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ref = try values.decode(DocumentReference.self, forKey: .ref)
    }
}

extension FirestoreDocumentRef {
    // MARK: - Rx

//    func asObservable() -> FirestoreDocumentRefRx<Document> {
//        FirestoreDocumentRefRx<Document>(ref)
//    }

    // MARK: - Operator

    public func get(completion: @escaping DocumentCompletion) {
        ref.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    do {
                        var document = try snapshot.data(as: Document.self)
                        document?.documentId = snapshot.documentID
                        completion(.success(document))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(FirestoreError.unknown))
                }
            }
        }
    }

    public func delete(completion: VoidCompletion?) {
        ref.delete(completion: completion)
    }

    public func setData(_ document: Document, completion: VoidCompletion?) {
        do {
            ref.setData(try document.asData(), completion: completion)
        } catch {
            completion?(error)
        }
    }

    // MARK: - Listen

    @discardableResult
    public func listen(completion: @escaping DocumentCompletion) -> ListenerRegistration {
        ref.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    do {
                        var document = try snapshot.data(as: Document.self)
                        document?.documentId = snapshot.documentID
                        completion(.success(document))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(FirestoreError.unknown))
                }
            }
        }
    }
}
