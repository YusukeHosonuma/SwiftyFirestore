//
//  FirestoreDocument.swift
//  Raito
//
//  Created by Yusuke Hosonuma on 2020/02/04.
//  Copyright © 2020 Kamui Project. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol FirestoreDocument: Codable {
    associatedtype CodingKeys: CodingKey

    static var collectionId: String { get }

    var documentId: String! { get set }

    init(_ snapshot: QueryDocumentSnapshot) throws

    func asData() throws -> [String: Any]
}

extension FirestoreDocument {
    public init(_ snapshot: QueryDocumentSnapshot) throws {
        do {
            var document = try Firestore.Decoder().decode(Self.self, from: snapshot.data())
            document.documentId = snapshot.documentID
            self = document
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
