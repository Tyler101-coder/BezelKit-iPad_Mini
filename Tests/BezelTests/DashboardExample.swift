import SwiftUI
import BezelKit

struct DashboardExample: View {

    var body: some View {
        Bezel {
            VStack(spacing: 20) {

                Text("Analytics")
                    .font(.largeTitle.bold())

                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 180)

                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 180)

                Spacer()
            }
            .padding()
        }
    }
}
