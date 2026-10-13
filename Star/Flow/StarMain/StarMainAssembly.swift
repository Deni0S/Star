import SwiftUI

struct StarMainAssembly {

    @MainActor func build(
        unauthorized: Binding<Bool>
    ) -> StarMainView {
        let appCoordinator = AppCoordinator.shared
        let viewModel = StarMainViewModel(
            authirizationHandlers: appCoordinator.managers.authorization)
        let view = StarMainView(
            viewModel: viewModel,
            unauthorized: unauthorized)
        return view
    }
}
