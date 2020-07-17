import SwiftUI
import WebRTC

struct VideoView: UIViewRepresentable {
    let remoteVideoTrack: RTCVideoTrack?

    func makeUIView(context: Context) -> RTCMTLVideoView {
        let view = RTCMTLVideoView(frame: .zero)
        view.videoContentMode = .scaleAspectFit
        return view
    }

    func updateUIView(_ uiView: RTCMTLVideoView, context: Context) {
        remoteVideoTrack?.add(uiView)
    }
}
