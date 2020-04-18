//
//  UpdateData.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/18.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import FirebaseFirestore

struct UpdateData<T: FirestoreData>: UpdateField {
    let key: String
    let value: T

    public func keyAndValue() throws -> (String, Any) {
        let data = try Firestore.Encoder().encode(value)
        return (key, data)
    }
}
