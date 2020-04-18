//
//  DocumentRef+Update.swift
//  SwiftyFirestore
//
//  Created by Yusuke Hosonuma on 2020/04/18.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

extension DocumentRef {
    public func update(fields: (UpdateFieldBuilder<Document>) -> Void) throws {
        try update(fields: fields) { _ in }
    }

    public func update(fields: (UpdateFieldBuilder<Document>) -> Void, completion: @escaping VoidCompletion) throws {
        let builder = UpdateFieldBuilder<Document>()
        fields(builder)

        let data = try builder.build()
        ref.updateData(data, completion: completion)
    }
}
