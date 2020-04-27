//
//  DocumentRef+SetData.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/18.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

extension DocumentRefProtocol {
    // TODO: avoid `try!`
    public func setData(_ document: Document) {
        ref.setData(try! document.asData())
    }

    public func setData(_ document: Document, completion: VoidCompletion?) {
        do {
            ref.setData(try document.asData(), completion: completion)
        } catch {
            completion?(error)
        }
    }
}
