import SwiftUI
import BezelKit

struct NavigationExample: View {
    var body: some View {
        Bezel {
            NavigationStack {
                List {
                    Text("Messages")
                    Text("Settings")
                    Text("Profile")
                }
                .navigationTitle("Demo")
            }
        }
    }
}
