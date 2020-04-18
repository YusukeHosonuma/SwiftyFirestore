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

    // MARK: Get

    public func get(completion: @escaping DocumentCompletion) {
        ref.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    do {
                        completion(.success(try Document(snapshot)))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    preconditionFailure("Expect to not reachable.")
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
                        completion(.success(try Document(snapshot)))
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

    public func update(fields: (UpdateFieldBuilder<Document>) -> Void) throws {
        try update(fields: fields) { _ in }
    }

    public func update(fields: (UpdateFieldBuilder<Document>) -> Void, completion: @escaping VoidCompletion) throws {
        let builder = UpdateFieldBuilder<Document>()
        fields(builder)

        let fields = try builder.build()
        let data = [String: Any](fields) { a, _ in a }
        ref.updateData(data, completion: completion)
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
    public func listen(includeMetadataChanges: Bool = false, completion: @escaping ListenerHandler) -> ListenerRegistration {
        ref.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    do {
                        let result = (try Document(snapshot), snapshot.metadata)
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
}
