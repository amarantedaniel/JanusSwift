import Janus
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var sessionCreated = false
    @Published var pluginAttached = false

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
            }
        }
    }
}

struct AppView: View {
    @ObservedObject var viewModel = AppViewModel()
    var body: some View {
        NavigationView {
            Form {
                CheckBoxItem(title: "Session created",
                             isChecked: viewModel.sessionCreated)
                CheckBoxItem(title: "Plugin attached",
                             isChecked: viewModel.pluginAttached)
            }
            .navigationBarTitle("Janus Streaming")
            .onAppear(perform: viewModel.createSession)
        }
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
