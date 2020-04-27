//
//  DocumentRef+.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/11.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

extension DocumentRefProtocol {
    func exists(completion: @escaping (Result<Bool, Error>) -> Void) {
        ref.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    completion(.success(snapshot.exists))
                } else {
                    preconditionFailure("Expect to not reachable.")
                }
            }
        }
    }
}
