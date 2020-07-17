import Janus
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var sessionCreated = false
    @Published var pluginAttached = false
    @Published var streams: [StreamInfo] = []
    @Published var selectedStream: StreamInfo?

    let session = JanusSession(baseUrl: URL(string: "https://janus.conf.meetecho.com/janus")!)

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
        session.watch(streamId: streamId) { sdp in
            print(sdp)
        }
    }
}
