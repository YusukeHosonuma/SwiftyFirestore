//
//  DocumentRef+Get.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/18.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

extension DocumentRef {
    // TODO: refactor
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
}
