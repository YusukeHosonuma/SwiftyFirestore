//
//  DocumentRef+Listen.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/18.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

extension DocumentRef {
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
