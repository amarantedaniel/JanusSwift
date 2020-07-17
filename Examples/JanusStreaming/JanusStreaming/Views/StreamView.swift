import SwiftUI

struct StreamView: View {
    @ObservedObject var viewModel: AppViewModel
    var body: some View {
        VideoView(remoteVideoTrack: viewModel.remoteVideoTrack)
            .onAppear(perform: viewModel.watch)
            .navigationBarTitle(viewModel.selectedStream?.description ?? "")
    }
}
