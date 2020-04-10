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
  - [x] `updateData()`
  - [ ] `updateData()` - nested object
  - [x] `FieldValue.arrayUnion()`
  - [x] `FieldValue.arrayRemove()`
  - [x] `FieldValue.increment()`
  - [x] `FieldValue.serverTimestamp()`
- Reference
  - [Query Data](https://firebase.google.com/docs/firestore/query-data/get-data?hl=ja)
    - [x] `getDocument()`
    - [x] `getDocument(source:)`
    - [x] `getDocuments()`
    - [x] `getDocuments(source:)`
  - [Queries](https://firebase.google.com/docs/firestore/query-data/queries?hl=ja)
    - [x] `whereField()`
      - [x] `<`
      - [x] `<=`
      - [x] `==`
      - [x] `>`
      - [x] `>=`
      - [x] `array-contains`
    - [x] Combination Query
    - [x] Collection Group - `collectionGroup()`
  - [x] [Order and Limit](https://firebase.google.com/docs/firestore/query-data/order-limit-data?hl=ja)
    - [x] `order(by:)`
    - [x] `order(by:, descending:)`
    - [x] `limit(to:)`
    - [x] `limit(toLast:)`
  - [Listen](https://firebase.google.com/docs/firestore/query-data/listen?hl=ja)
    - [x] Document
      - [x] `addSnapshotListener()`
      - [x] `addSnapshotListener(includeMetadataChanges:)`
      - [x] `metadata.hasPendingWrites`
      - [x] `listener.remove()`
    - [x] Collection
      - [x] `addSnapshotListener()`
      - [x] `addSnapshotListener(includeMetadataChanges:)`
      - [x] `metadata.hasPendingWrites`
      - [x] `listener.remove()`
      - [x] `snapshot.documentChanges`
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
  - Other
    - [ ] `exists`
- [Delete](https://firebase.google.com/docs/firestore/manage-data/delete-data?hl=ja)
  - [x] `delete()`
  - [x] `FieldValue.delete`
- [Transaction / Batch](https://cloud.google.com/firestore/docs/manage-data/transactions?hl=ja)
  - Transaction
    - [x] `runTransaction()`
    - [x] `transaction.getDocument()`
    - [x] `transaction.updateData()`
    - [ ] `transaction.xxx()`
  - Batch
    - [x] `batch.setData()`
    - [x] `batch.updateData()`
    - [x] `batch.deleteDocument()`
    - [ ] `batch.xxx()`
    - [x] `batch.commit()`
- Other
  - [x] Document Reference Type

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
