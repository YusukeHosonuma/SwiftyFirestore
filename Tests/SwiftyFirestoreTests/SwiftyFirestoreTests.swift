import XCTest
@testable import SwiftyFirestore
import Firebase
import FirebaseFirestore

final class SwiftyFirestoreTests: XCTestCase {
    override func setUp() {
        FirestoreTestHelper.setupFirebaseApp()
    }
    
    override class func tearDown() {
        FirestoreTestHelper.deleteFirebaseApp()
    }
    
    func testAdd() throws {
        let document = TodoDocument(documentId: nil, title: "Hello", done: false)
        
        Firestore.root
            .todos
            .add(document)
        
        let exp = self.expectation(description: "")
        
        Firestore.root.todos.getAll { (result) in
            guard case let .success(documents) = result else { XCTFail(); return }
            
            XCTAssertEqual(documents.count, 1)
            XCTAssertEqual(documents[0].title,  document.title)
            XCTAssertEqual(documents[0].done,  document.done)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10)
    }
}
