import SwiftUI

final class AuthorizationViewModel: ObservableObject {

    private let authirizationHandlers: AuthorizationHandlersInterface

    init(
        authirizationHandlers: AuthorizationHandlersInterface
    ) {
        self.authirizationHandlers = authirizationHandlers
    }
}
