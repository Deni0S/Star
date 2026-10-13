import SwiftUI

struct AuthorizationAssembly {

    @MainActor func build(
        star: Namespace.ID,
        authorized: Binding<Bool>
    ) -> AuthorizationView {
        let appCoordinator = AppCoordinator.shared
        let viewModel = AuthorizationViewModel(
            authirizationHandlers: appCoordinator.managers.authorization)
        let view = AuthorizationView(
            viewModel: viewModel,
            authorized: authorized,
            star: star)
        return view
    }
}
