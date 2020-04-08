# SwiftyFirestore

a.k.a *Firestore on the S(wift) strings - S線上のFirestore*

**⚠️ This product is currently under development.**

## References

- [Firestore Document](https://firebase.google.com/docs/firestore?hl=ja)
- [API Reference](https://firebase.google.com/docs/reference/swift/firebasefirestore/api/reference/Classes?hl=ja)

## TODO

- [Create / Update](https://firebase.google.com/docs/firestore/manage-data/add-data?hl=ja)
  - [x] `setData()`
  - [ ] `setData(merge:)`
  - [x] `add()`
  - [ ] `updateData()`
  - [ ] `updateData()` - nested object
  - [ ] `FieldValue.arrayUnion()`
  - [ ] `FieldValue.arrayRemove()`
  - [ ] `FieldValue.increment()`
- Reference
  - [Query Data](https://firebase.google.com/docs/firestore/query-data/get-data?hl=ja)
    - [x] `getDocument()`
    - [ ] `getDocument(source:)`
    - [x] `getDocuments()`
  - [Queries](https://firebase.google.com/docs/firestore/query-data/queries?hl=ja)
    - [ ] `whereField()`
      - [x] `<`
      - [x] `<=`
      - [x] `==`
      - [x] `>`
      - [x] `>=`
      - [ ] `array-contains`
    - [x] Combination Query
    - [x] Collection Group - `collectionGroup()`
  - [x] [Order and Limit](https://firebase.google.com/docs/firestore/query-data/order-limit-data?hl=ja)
    - [x] `order(by:)`
    - [x] `order(by:, descending:)`
    - [x] `limit(to:)`
    - [x] `limit(toLast:)`
  - [Listen](https://firebase.google.com/docs/firestore/query-data/listen?hl=ja)
    - [x] `addSnapshotListener()`
    - [ ] `addSnapshotListener(includeMetadataChanges:)`
    - [ ] `metadata.hasPendingWrites`
    - [ ] `snapshot.documentChanges`
    - [x] `listener.remove()`
  - [Query cursors](https://firebase.google.com/docs/firestore/query-data/query-cursors?hl=ja)
    - [ ] `start(at:)`
    - [ ] `start(after:)`
    - [ ] `start(afterDocument:)`
    - [ ] `end(at:)`
    - [ ] `end(before:)`
    - [ ] `end(beforeDocument:)`
    - [ ] with Document Snapshot
    - [ ] multi-cursor
  - [Enable offline](https://firebase.google.com/docs/firestore/manage-data/enable-offline?hl=ja)
    - T.B.D
- Delete
  - [ ] `delete()`
  - [ ] `FieldValue.delete`
- Transaction
  - [ ] `runTransaction()`
- Batch
  - [ ] `commit()`
- Other
  - [ ] `FieldValue.serverTimestamp()`

## API Difference (WIP)

| Firestore | SwiftyFirestore |
|-----------|-----------------|
| `CollectionReference.addDocument()` | `FirestoreCollectionRef.add()` |
| `DocumentReference.setData()` | `FirestoreDocumentRef.setData()` |
| `DocumentReference.getDocuments()` | `FirestoreDocumentRef.getAll()` |

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
