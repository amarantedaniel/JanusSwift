@testable import Janus
import XCTest

final class JanusTests: XCTestCase {
    func testExample() {
        let janus = Janus()
        let expectation = XCTestExpectation()
        janus.createSession { sessionId in
            janus.attachPlugin(sessionId: sessionId, plugin: .streaming) { value in
                print(value)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
