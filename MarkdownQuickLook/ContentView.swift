import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Markdown Quick Look")
                .font(.title2.weight(.semibold))
            Text("The preview extension is installed with this app.")
                .foregroundStyle(.secondary)
            Text("Select a .md or .markdown file in Finder, then press Space to preview it.")
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(28)
    }
}
