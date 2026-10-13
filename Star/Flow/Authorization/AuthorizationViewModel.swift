import SwiftUI

final class AuthorizationViewModel: ObservableObject {

    private let authirizationHandlers: AuthorizationInterface

    init(
        authirizationHandlers: AuthorizationInterface
    ) {
        self.authirizationHandlers = authirizationHandlers
    }
}
