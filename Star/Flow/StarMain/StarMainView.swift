import SwiftUI

struct StarMainView: View {

    @ObservedObject var viewModel: StarMainViewModel

    @Binding var unauthorized: Bool

    var body: some View {
        ZStack {
            Color.customAccent

            Button("Tap me") {
                viewModel.logOut()
                unauthorized.toggle()
            }
            .font(Font.custom("Nunito-Bold", size: 18))
            .frame(width: 200, height: 50)
            .background(Color.customFFFFFF000000)
            .cornerRadius(20)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    StarMainAssembly().build(
        unauthorized: .constant(true))
}
