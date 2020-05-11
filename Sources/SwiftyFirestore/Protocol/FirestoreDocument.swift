//
//  FirestoreDocument.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/02/04.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol FirestoreDocument: Codable {
    associatedtype CodingKeys: CodingKey

    static var collectionID: String { get }

    var documentReference: DocumentRef<Self>! { get set }

    init(_ snapshot: QueryDocumentSnapshot) throws
    init?(_ snapshot: DocumentSnapshot) throws

    func asData() throws -> [String: Any]
}

extension FirestoreDocument {
    var collectionID: String {
        Self.collectionID
    }

    // TODO: tests

    public init(_ snapshot: QueryDocumentSnapshot) throws {
        do {
            var document = try snapshot.data(as: Self.self)! // Always success because `QueryDocumentSnapshot#data()` returns not `nil`.
            document.documentReference = DocumentRef(ref: snapshot.reference)
            self = document
        } catch {
            throw FirestoreError.decodeFailed(error)
        }
    }

    public init?(_ snapshot: DocumentSnapshot) throws {
        do {
            var document = try snapshot.data(as: Self.self)
            document?.documentReference = DocumentRef(ref: snapshot.reference)
            if let document = document {
                self = document
            } else {
                return nil
            }
        } catch {
            throw FirestoreError.decodeFailed(error)
        }
    }

    public func asData() throws -> [String: Any] {
        do {
            return try Firestore.Encoder().encode(self)
        } catch {
            throw FirestoreError.encodeFailed(error)
        }
    }
}
