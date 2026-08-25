import SwiftUI
import BezelKit

struct DashboardExample: View {
    var body: some View {
        Bezel {
            VStack {
                Text("Analytics")
                    .font(.largeTitle.bold())

                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 160)

                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 160)
            }
            .padding()
        }
    }
}
