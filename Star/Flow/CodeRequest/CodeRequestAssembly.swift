import SwiftUICore

struct CodeRequestAssembly {

    func build(
        star: Namespace.ID,
        phoneNumber: String,
        nextStep: Binding<Bool>
    ) -> CodeRequestView {
        let appCoordinator = AppCoordinator.shared
        let viewModel = CodeRequestViewModel(
            authirizationHandlers: appCoordinator.managers.authorization,
            phoneNumber: phoneNumber,
            nextStep: nextStep)
        let view = CodeRequestView(
            viewModel: viewModel,
            star: star)
        return view
    }
}
