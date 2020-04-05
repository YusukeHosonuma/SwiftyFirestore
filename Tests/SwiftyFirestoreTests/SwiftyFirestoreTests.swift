import XCTest
@testable import SwiftyFirestore
import Firebase
import FirebaseFirestore

final class SwiftyFirestoreTests: XCTestCase {
    override func setUp() {
    }
    
    override class func tearDown() {
    }
    
    func testAdd() throws {
        
        let document = TodoDocument(documentId: nil, title: "Hello", done: false)

        try assertSameBehavior(
            swifty: {
                //
                // Swifty
                //
                Firestore.root.todos.add(document)
            },
            original: {
                //
                // Original
                //
                Firestore.firestore().collection("todos").addDocument(data: try document.asData())
            },
            expect: {
                let exp = self.expectation(description: "#")
                Firestore.firestore().collection("todos").getDocuments { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return }
                    let documents = snapshot.documents.compactMap {
                        try? Firestore.Decoder().decode(TodoDocument.self, from: $0.data())
                    }
                    XCTAssertEqual(documents.count, 1)
                    XCTAssertEqual(documents.first?.title,  document.title)
                    XCTAssertEqual(documents.first?.done,  document.done)
                    exp.fulfill()
                }
                wait(for: [exp], timeout: 3)
            }
        )
    }
    
    func testGetAll() throws {
        FirestoreTestHelper.setupFirebaseApp()
        
        let datas = [
            TodoDocument(documentId: nil, title: "Hello", done: false),
            TodoDocument(documentId: nil, title: "World", done: true),
        ].map { try! Firestore.Encoder().encode($0) }

        for data in datas {
            Firestore.firestore().collection("todos").addDocument(data: data)
        }
        
        assertSameResult(
            resultType: [TodoDocument].self,
            swifty: { completion in
                //
                // Swifty
                //
                Firestore.root.todos.getAll { result in
                    guard case .success(let documents) = result else { XCTFail(); return }
                    completion(documents)
                }
            },
            original: { completion in
                //
                // Original
                //
                Firestore.firestore().collection("todos").getDocuments { (snapshot, error) in
                    guard let snapshot = snapshot else { XCTFail(); return }
                    let documents: [TodoDocument] = snapshot.documents.compactMap {
                        var document = try? Firestore.Decoder().decode(TodoDocument.self, from: $0.data())
                        document?.documentId = $0.documentID
                        return document
                    }
                    completion(documents)
                }
            }
        )
        
        FirestoreTestHelper.deleteFirebaseApp()
    }
    
    typealias Handler = () throws -> Void
    typealias Completion<T> = (T) -> Void

    func assertSameBehavior(swifty: Handler, original: Handler, expect: () -> Void) rethrows {
        FirestoreTestHelper.setupFirebaseApp()
        try swifty()
        expect()
        FirestoreTestHelper.deleteFirebaseApp()

        FirestoreTestHelper.setupFirebaseApp()
        try original()
        expect()
        FirestoreTestHelper.deleteFirebaseApp()
    }
    
    func assertSameResult<T: Equatable>(resultType: T.Type, swifty: (@escaping Completion<T>) -> Void, original: (@escaping Completion<T>) -> Void) {
        
        var  documents1: T? = nil
        var  documents2: T? = nil
        
        let exp1 = expectation(description: "#1")
        let exp2 = expectation(description: "#2")
        
        swifty { result in
            documents1 = result
            exp1.fulfill()
        }
        
        original { result in
            documents2 = result
            exp2.fulfill()
        }

        wait(for: [exp1, exp2], timeout: 3)

        XCTAssertNotNil(documents1)
        XCTAssertNotNil(documents2)
        XCTAssertEqual(documents1, documents2)
    }
}
