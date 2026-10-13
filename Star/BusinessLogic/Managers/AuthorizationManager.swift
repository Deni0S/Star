import SwiftUI

// MARK: - Interfaces

typealias AuthorizationInterface = Sendable & AuthorizationHandlersInterface

protocol AuthorizationHandlersInterface: Sendable {
    /// Requesting an authorization code
    func codeRequest(_ phoneNumber: String) async
    /// Checking the text message code for authorization
    func checkSmsCode(_ code: String) async -> Bool
}

// MARK: - Authorization Manager

final actor AuthorizationManager {

    private let loger: LoggingInterface

    private let smsCode = "12345"

    init(
        loger: LoggingInterface
    ) {
        self.loger = loger
    }
}

// MARK: - Authorization Handlers

extension AuthorizationManager: AuthorizationInterface {

    func codeRequest(
        _ phoneNumber: String
    ) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            Task {
                await self?.codeFromLocalPush(phoneNumber)
            }
        }
    }

    func checkSmsCode(
        _ code: String
    ) async -> Bool {
        sleep(1)
        return code == smsCode
    }
}

// MARK: - Private

private extension AuthorizationManager {

    func codeFromLocalPush(
        _ phoneNumber: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("10", comment: "")
        content.body = "\(phoneNumber)"
        content.sound = UNNotificationSound.default
        content.userInfo = ["smsCode": "12345"]
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: 0.5,
                repeats: false))
        Task {
            do {
                try await UNUserNotificationCenter.current().add(request)
            } catch {
                await loger.debug(.error(error))
            }
        }
    }
}
