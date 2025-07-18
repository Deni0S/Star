import SwiftUI

final class StarMainViewModel: ObservableObject {

    private let authirizationHandlers: AuthorizationHandlersInterface

    init(
        authirizationHandlers: AuthorizationHandlersInterface
    ) {
        self.authirizationHandlers = authirizationHandlers
    }

    func logOut() {

    }
}
