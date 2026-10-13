import SwiftUI

struct PhoneRequestAssembly {

    @MainActor func build(
        star: Namespace.ID,
        nextStep: Binding<String>
    ) -> PhoneRequestView {
        let appCoordinator = AppCoordinator.shared
        let viewModel = PhoneRequestViewModel(
            authirizationHandlers: appCoordinator.managers.authorization,
            nextStep: nextStep)
        let view = PhoneRequestView(
            viewModel: viewModel,
            star: star)
        return view
    }
}
