import Janus
import SwiftUI
import WebRTC

class AppViewModel: ObservableObject {
    @Published var sessionCreated = false
    @Published var pluginAttached = false
    @Published var streams: [StreamInfo] = []
    @Published var selectedStream: StreamInfo?
    @Published var remoteVideoTrack: RTCVideoTrack?

    let session = JanusSession(baseUrl: URL(string: "https://janus.conf.meetecho.com/janus")!)
    let webRTCClient = WebRTCClient()

    init() {
        webRTCClient.delegate = self
    }

    func setup() {
        session.createSession { [unowned self] in
            DispatchQueue.main.async {
                self.sessionCreated = true
            }
            self.session.attachPlugin(plugin: .streaming) {
                DispatchQueue.main.async {
                    self.pluginAttached = true
                }
                self.session.list { streams in
                    DispatchQueue.main.async {
                        self.streams = streams
                    }
                }
            }
        }
    }

    func watch() {
        guard let streamId = selectedStream?.id else { return }
        session.watch(streamId: streamId) { [unowned self] remoteSdp in
            self.webRTCClient.answer(remoteSdp: remoteSdp) { [unowned self] localSdp in
                self.session.start(sdp: localSdp) {}
            }
        }
    }
}

extension AppViewModel: WebRTCClientDelegate {
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        session.trickle(candidate: candidate.sdp, sdpMLineIndex: Int(candidate.sdpMLineIndex), sdpMid: candidate.sdpMid!) {}
    }

    func webRTCClient(_ client: WebRTCClient, didSetRemoteVideoTrack remoteVideoTrack: RTCVideoTrack) {
        DispatchQueue.main.async {
            self.remoteVideoTrack = remoteVideoTrack
        }
    }
}
