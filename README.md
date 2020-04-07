# SwiftyFirestore

a.k.a *Firestore on the S(wift) strings - S線上のFirestore*

**⚠️ This product is currently under development.**

## TODO

T.B.D

## Preparation

### Step.1 - Define Document Structure

Please define each document structure that adopt to `FirestoreDocument` protocol.

**Note: `CodingKeys` is required, unlike typical `Codable`.**

```swift
struct AccountDocument: FirestoreDocument {
    static let collectionId: String = "account" // enclosing collection name

    var documentId: String!
    var name: String

    enum CodingKeys: String, CodingKey {
        case documentId
        case name
    }
}

struct RepositoryDocument: FirestoreDocument {
    static let collectionId: String = "repository" // enclosing collection name

    var documentId: String!
    var language: String
    var star: Int

    enum CodingKeys: String, CodingKey {
        case documentId
        case language
        case star
    }
}
```

### Step.2 - Define Document Tree Structure in Firestore

Please define document tree structure.

```swift
// Tree structure:
//
// "account": [
//   "{id}": AccountDocument {
//     "reposiotry": [
//       "{id}": RepositoryDocument
//     ]
//   }
// ]

extension RootRef {
    var account: AccountCollectionRef { AccountCollectionRef(ref) }
    func account(id: String) -> AccountDocumentRef { AccountDocumentRef(ref, id: id) }
}

class AccountCollectionRef: FirestoreCollectionRefBase<AccountDocument> {}

class AccountDocumentRef: FirestoreDocumentRef<AccountDocument> {
    var repository: RepositoryCollectionRef { RepositoryCollectionRef(ref) }
}

class RepositoryCollectionRef: FirestoreCollectionRefBase<RepositoryDocument> {}
```

## Let's enjoy SwiftyFirestore

All codes are typesafe.

```swift
Firestore.root
    .account(id: "YusukeHosonuma")
    .repository
    .whereBy(.language, "==", "Swift")
    .whereBy(.star, ">", "10")
    .orderBy(.star, sort: .descending)
    .limitTo(3)
    .getAll { result in
        guard case .success(let documents) = result else { return }
        print(documents) // [RepositoryDocument]
    }
```
