
import SwiftUI
import Bezel

struct BasicExample: View {
    
    var body: some View {
        Bezel {
            VStack {
                Image(systemName: "iphone")
                    .font(.largeTitle)

                Text("Hello Bezel")
                    .font(.title)
            }
            .padding()
        }
    }
}
