//
//  FirestoreTestHelper.swift
//  SwiftyFirestoreTests
//
//  Created by Yusuke Hosonuma on 2020/04/02.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import Firebase
import FirebaseFirestore

private let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "en-US")
    f.dateFormat = "yyyyMMddHHmmss"
    return f
}()

// ref: https://tech-blog.sgr-ksmt.org/2019/09/28/180821/
class FirestoreTestHelper {
    static func setupFirebaseApp() {
        if FirebaseApp.app() == nil {
            let options = FirebaseOptions(googleAppID: "1:123:ios:123abc", gcmSenderID: "sender_id")
            options.projectID = "test-" + dateFormatter.string(from: Date())
            FirebaseApp.configure(options: options)
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
            print("🔥 FirebaseApp has been configured")
        }
    }
    
    static func deleteFirebaseApp() {
        guard let app = FirebaseApp.app() else {
            return
        }
        app.delete { _ in print("🔥 FirebaseApp has been deleted") }
    }
}
