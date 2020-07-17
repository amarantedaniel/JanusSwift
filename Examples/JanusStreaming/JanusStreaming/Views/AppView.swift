
import SwiftUI

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
                        NavigationLink(destination: StreamView(viewModel: self.viewModel),
                                       tag: stream,
                                       selection: self.$viewModel.selectedStream) {
                            Text(stream.description)
                        }
                    }
                }
            }
            .navigationBarTitle("Streaming")
            .onAppear(perform: viewModel.setup)
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
