//
//  Alias.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/10.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import Foundation

extension CollectionRef {
    public func callAsFunction(path: String) -> DocumentRef<Document> {
        document(path)
    }
}
