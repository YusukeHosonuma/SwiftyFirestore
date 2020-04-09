//
//  WhereCriteria.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/09.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

public struct FirestoreCriteria<T: FirestoreDocument> {
    public var key: T.CodingKeys
    public var value: Any
    public var op: WhereOperator
}
