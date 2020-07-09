@testable import Janus
import XCTest

final class JanusTests: XCTestCase {
    func testExample() {
        let janus = Janus()
        let expectation = XCTestExpectation()
        janus.createSession { sessionId in
            janus.attachPlugin(sessionId: sessionId, plugin: .streaming) { handleId in
                janus.watch(sessionId: sessionId, handleId: handleId) { jsep in
                    print(jsep)
                    expectation.fulfill()
                }
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
