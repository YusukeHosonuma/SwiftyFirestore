//
//  Firestore+Error.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/02/13.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

public enum FirestoreError: Error {
    case encodeFailed(Error)
    case decodeFailed(Error)
    case unknown
}
