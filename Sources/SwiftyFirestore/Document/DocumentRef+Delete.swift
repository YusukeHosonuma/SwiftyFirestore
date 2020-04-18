//
//  DocumentRef+Delete.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/18.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

extension DocumentRef {
    public func delete() {
        ref.delete()
    }

    public func delete(completion: VoidCompletion?) {
        ref.delete(completion: completion)
    }
}
