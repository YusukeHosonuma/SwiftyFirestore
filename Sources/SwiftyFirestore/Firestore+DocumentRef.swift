//
//  Firestore+DocumentRef.swift
//  Raito
//
//  Created by Yusuke Hosonuma on 2020/02/13.
//  Copyright © 2020 Kamui Project. All rights reserved.
//

import FirebaseFirestore

open class FirestoreDocumentRef<Document: FirestoreDocument>: Codable {
    public typealias Key = Document.CodingKeys

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

    // MARK: - Get

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

    public func get(source: FirestoreSource, completion: @escaping DocumentCompletion) {
        ref.getDocument(source: source) { snapshot, error in
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

    // MARK: Update

    public func update(_ fields: [UpdateField<Document>]) {
        let data = fields.map { $0.keyAndValue() }
        let fields = [String: Any](data) { a, _ in a }

        ref.updateData(fields)
    }

    public func update(_ fields: [UpdateField<Document>], completion: @escaping VoidCompletion) {
        let data = fields.map { $0.keyAndValue() }
        let fields = [String: Any](data) { a, _ in a }

        ref.updateData(fields, completion: completion)
    }

    // MARK: Delete

    public func delete() {
        ref.delete()
    }

    public func delete(completion: VoidCompletion?) {
        ref.delete(completion: completion)
    }

    // MARK: Update

    public func setData(_ document: Document) {
        ref.setData(try! document.asData())
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
        listen(includeMetadataChanges: false, completion: completion)
    }

    @discardableResult
    public func listen(includeMetadataChanges: Bool, completion: @escaping DocumentCompletion) -> ListenerRegistration {
        ref.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
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
