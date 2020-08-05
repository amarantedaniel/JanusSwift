import Janus
import SwiftUI
import WebRTC

class AppViewModel: ObservableObject {
    @Published var sessionId: Int?
    @Published var handleId: Int?
    @Published var streams: [StreamInfo] = []
    @Published var selectedStream: StreamInfo?
    @Published var started = false
    @Published var remoteVideoTrack: RTCVideoTrack?

    let session = JanusAPI(baseUrl: URL(string: "https://janus.conf.meetecho.com/janus")!)
    let webRTCClient = WebRTCClient()

    init() {
        webRTCClient.delegate = self
    }

    func setup() {
        session.createSession { [unowned self] sessionId in
            DispatchQueue.main.async {
                self.sessionId = sessionId
            }
            self.session.attachPlugin(sessionId: sessionId, plugin: .streaming) { [unowned self] handleId in
                DispatchQueue.main.async {
                    self.handleId = handleId
                }
                self.session.list(sessionId: sessionId, handleId: handleId) { streams in
                    DispatchQueue.main.async {
                        self.streams = streams
                    }
                }
            }
        }
    }

    func watch() {
        guard let sessionId = sessionId else { return }
        guard let handleId = handleId else { return }
        guard let streamId = selectedStream?.id else { return }
        session.watch(sessionId: sessionId, handleId: handleId, streamId: streamId) { [unowned self] remoteSdp in
            self.webRTCClient.answer(remoteSdp: remoteSdp) { [unowned self] localSdp in
                self.session.start(sessionId: sessionId, handleId: handleId, sdp: localSdp) { [unowned self] in
                    DispatchQueue.main.async {
                        self.started = true
                    }
                }
            }
        }
    }
}

extension AppViewModel: WebRTCClientDelegate {
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        guard let sessionId = sessionId else { return }
        guard let handleId = handleId else { return }
        session.trickle(sessionId: sessionId,
                        handleId: handleId,
                        candidate: candidate.sdp,
                        sdpMLineIndex: candidate.sdpMLineIndex,
                        sdpMid: candidate.sdpMid) {}
    }

    func webRTCClient(_ client: WebRTCClient, didSetRemoteVideoTrack remoteVideoTrack: RTCVideoTrack) {
        DispatchQueue.main.async {
            self.remoteVideoTrack = remoteVideoTrack
        }
    }
}
