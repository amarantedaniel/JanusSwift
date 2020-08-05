@testable import Janus
import XCTest

final class JanusSessionTests: XCTestCase {
    var session: JanusAPI!

    override func setUp() {
        session = JanusAPI(apiClient: APIClientStub())
    }

    func test_create_shouldStoreSessionIdAndCallCallback() {
        let expectation = XCTestExpectation()
        var sessionId: Int?
        session.createSession {
            sessionId = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
        XCTAssertEqual(sessionId, 123)
    }

    func test_attachPlugin_withStreamingPlugin_shouldStoreHandleIdAndCallCallback() {
        let expectation = XCTestExpectation()
        var handleId: Int?
        session.attachPlugin(sessionId: 123, plugin: .streaming) {
            handleId = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
        XCTAssertEqual(handleId, 456)
    }

    func test_watch_withStringId_ShouldReturnSdp() {
        let expectation = XCTestExpectation()
        var generatedSdp: String?
        session.watch(sessionId: 123, handleId: 456, streamId: "streamId") { sdp in
            generatedSdp = sdp
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
        XCTAssertEqual(generatedSdp, "fake-sdp")
    }

    func test_watch_withIntId_ShouldReturnSdp() {
        let expectation = XCTestExpectation()
        var generatedSdp: String?
        session.watch(sessionId: 123, handleId: 456, streamId: 9999) { sdp in
            generatedSdp = sdp
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
        XCTAssertEqual(generatedSdp, "fake-sdp")
    }

    func test_start_callsCallback() {
        let expectation = XCTestExpectation()
        session.start(sessionId: 123, handleId: 456, sdp: "fake-sdp-answer") {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
    }

    func test_trickle_callsCallback() {
        let expectation = XCTestExpectation()
        session.trickle(sessionId: 123, handleId: 456, candidate: "candidate", sdpMLineIndex: 0, sdpMid: "video") {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
    }

    func test_list_callsCallbackWithListOfStreams() {
        let expectation = XCTestExpectation()
        var fetchedStreams = [StreamInfo]()
        session.list(sessionId: 123, handleId: 456) { streams in
            fetchedStreams = streams
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.001)
        XCTAssertEqual(fetchedStreams[0].description, "stream")
        XCTAssertEqual(fetchedStreams[0].id, 10)
    }
}
