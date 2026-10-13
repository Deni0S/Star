import SwiftUI

final class StarMainViewModel: ObservableObject {

    private let authirizationHandlers: AuthorizationInterface

    init(
        authirizationHandlers: AuthorizationInterface
    ) {
        self.authirizationHandlers = authirizationHandlers
    }

    func logOut() {

    }
}
