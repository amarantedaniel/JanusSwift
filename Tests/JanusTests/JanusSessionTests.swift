@testable import Janus
import XCTest

final class JanusSessionTests: XCTestCase {
    var session: JanusSession!

    override func setUp() {
        session = JanusSession(apiClient: APIClientStub())
    }

    func test_create_shouldStoreSessionIdAndCallCallback() {
        let expectation = XCTestExpectation()
        session.createSession {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
        XCTAssertEqual(session.sessionId, 123)
    }

    func test_attachPlugin_withStreamingPlugin_shouldStoreHandleIdAndCallCallback() {
        let expectation = XCTestExpectation()
        session.sessionId = 123
        session.attachPlugin(plugin: .streaming) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
        XCTAssertEqual(session.handleId, 456)
    }

    func test_watch_withStringId_ShouldReturnSdp() {
        let expectation = XCTestExpectation()
        var generatedSdp: String?
        session.sessionId = 123
        session.handleId = 456
        session.watch(streamId: "streamId") { sdp in
            generatedSdp = sdp
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
        XCTAssertEqual(generatedSdp, "fake-sdp")
    }

    func test_watch_withIntId_ShouldReturnSdp() {
        let expectation = XCTestExpectation()
        var generatedSdp: String?
        session.sessionId = 123
        session.handleId = 456
        session.watch(streamId: 9999) { sdp in
            generatedSdp = sdp
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
        XCTAssertEqual(generatedSdp, "fake-sdp")
    }

    func test_start_callsCallback() {
        let expectation = XCTestExpectation()
        session.sessionId = 123
        session.handleId = 456
        session.start(sdp: "fake-sdp-answer") {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
    }
    
    func test_trickle_callsCallback() {
        let expectation = XCTestExpectation()
        session.sessionId = 123
        session.handleId = 456
        session.trickle(candidate: "candidate", sdpMLineIndex: 0, sdpMid: "video") {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
    }
    
    func test_list_callsCallbackWithListOfStreams() {
        let expectation = XCTestExpectation()
        var fetchedStreams = [StreamInfo]()
        session.sessionId = 123
        session.handleId = 456
        session.list { (streams) in
            fetchedStreams  = streams
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
        XCTAssertEqual(fetchedStreams[0].description, "stream")
        XCTAssertEqual(fetchedStreams[0].id, 10)
    }
}
