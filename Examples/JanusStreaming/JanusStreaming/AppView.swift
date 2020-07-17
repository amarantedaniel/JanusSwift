import Janus
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var sessionCreated = false
    @Published var pluginAttached = false
    @Published var streams: [StreamInfo] = []

    let session = JanusSession(baseUrl: URL(string: "https://janus.conf.meetecho.com/janus")!)

    func createSession() {
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
}

struct AppView: View {
    @ObservedObject var viewModel = AppViewModel()
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("STATUS")) {
                    CheckBoxItem(title: "Session created",
                                 isChecked: viewModel.sessionCreated)
                    CheckBoxItem(title: "Plugin attached",
                                 isChecked: viewModel.pluginAttached)
                }
                Section(header: Text("STREAMS")) {
                    ForEach(viewModel.streams, id: \.id) { stream in
                        NavigationLink(destination: StreamView()) {
                            Text(stream.description)
                        }
                    }
                }
            }
            .navigationBarTitle("Janus Streaming")
            .onAppear(perform: viewModel.createSession)
        }
    }
}

struct StreamView: View {
    var body: some View {
        Text("oi")
    }
}

struct CheckBoxItem: View {
    let title: String
    let isChecked: Bool

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(isChecked ? "✅" : "❌")
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
