import SwiftUI

struct AppLaunchScreenView: View {

    var star: Namespace.ID

    var body: some View {
        ZStack {
            Color.customAccent

            Image("BackgroundStarIcon")
                .resizable()
                .matchedGeometryEffect(id: "MatchedBackground", in: star)

            Image("StarLeftHandIcon")
                .matchedGeometryEffect(id: "MatchedStar", in: star)
        }
        .ignoresSafeArea()
    }
}

struct AppLaunchScreenView_Previews: PreviewProvider {
    @Namespace static var mockStar
    static var previews: some View {
        AppLaunchScreenView(
            star: mockStar)
    }
}
