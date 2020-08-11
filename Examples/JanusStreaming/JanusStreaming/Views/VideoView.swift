import SwiftUI
import WebRTC

#if arch(arm64)
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
#else
struct VideoView: UIViewRepresentable {
    let remoteVideoTrack: RTCVideoTrack?

    func makeUIView(context: Context) -> RTCEAGLVideoView {
        RTCEAGLVideoView(frame: .zero)
    }

    func updateUIView(_ videoView: RTCEAGLVideoView, context: Context) {
        remoteVideoTrack?.add(videoView)
    }
}
#endif
