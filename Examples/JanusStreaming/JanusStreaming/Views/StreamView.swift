import SwiftUI

struct StreamView: View {
    @ObservedObject var viewModel: AppViewModel
    var body: some View {
        Text("oi")
            .onAppear(perform: viewModel.watch)
            .navigationBarTitle(viewModel.selectedStream?.description ?? "")
    }
}
