import SwiftUI

struct AuthorizationView: View {

    @ObservedObject var viewModel: AuthorizationViewModel

    @Binding var authorized: Bool

    @State private var showCodeScreen = ""

    var star: Namespace.ID

    var body: some View {
        ZStack {
            if showCodeScreen.isEmpty {
                PhoneRequestAssembly().build(
                    star: star,
                    nextStep: $showCodeScreen)
            } else {
                CodeRequestAssembly().build(
                    star: star,
                    phoneNumber: showCodeScreen,
                    nextStep: $authorized)
            }
        }
        .animation(.bouncy, value: showCodeScreen)
    }
}

struct PlayView_Previews: PreviewProvider {
    @Namespace static var mockStar
    static var previews: some View {
        AuthorizationAssembly().build(
            star: mockStar,
            authorized: .constant(false))
    }
}
