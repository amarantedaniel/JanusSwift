@testable import Janus
import XCTest

final class JanusTests: XCTestCase {
    func testExample() {
        let session = JanusSession(baseUrl: URL(string: "http://localhost:8088/janus")!)
        let expectation = XCTestExpectation()
        session.createSession {
            session.attachPlugin(plugin: .streaming) {
                session.watch { sdp in
                    session.start(sdp: sdp) {
                        session.trickle(candidate: "candidate:608181405 1 udp 1685987071 189.6.237.77 27004 typ srflx raddr 192.168.0.9 rport 61921 generation 0 ufrag sX\\/4 network-id 1 network-cost 10",
                                        sdpMLineIndex: 0,
                                        sdpMid: "audio") {
                            print("terminei")
                            expectation.fulfill()
                        }
                    }
                }
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
