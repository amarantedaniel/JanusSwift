import SwiftUI

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
