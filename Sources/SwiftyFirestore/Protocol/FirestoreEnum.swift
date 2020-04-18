//
//  FirestoreEnum.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/18.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

public protocol FirestoreEnum: Codable {
    associatedtype RawValue
    var rawValue: RawValue { get }
}
