import SwiftUI

// MARK: - Interfaces

typealias PushInterface = Sendable & PushAuthorizationInterface & RemoteNotificationsInterface & UserNotificationCenterInterface

protocol PushAuthorizationInterface: Sendable {
    /// Check the possibility to register for remote notifications
    func requestAuthorization() async
    /// Register to receive silent messages
    func silentAuthorization() async
}

protocol RemoteNotificationsInterface: Sendable {
    /// Successfully registered with APNs
    func didRegisterForRemoteNotificationsWithDeviceToken(_ token: Data)
    /// Cannot successfully complete the registration process APNs
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error)
    /// App has received a remote notification
    func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any])
}

protocol UserNotificationCenterInterface: Sendable {
    /// Process a notification received while the app is running in the foreground
    func willPresent(_ notification: UNNotification)
}

// MARK: - Push Manager

final actor PushManager: NSObject {

    private let logger: LoggingSendingInterface

    init (
        logger: LoggingSendingInterface
    ) {
        self.logger = logger
    }
}

// MARK: - Push Authorization

extension PushManager: PushAuthorizationInterface {

    func requestAuthorization() {
        let options: UNAuthorizationOptions =  [.alert, .sound, .carPlay]
        registerForRemoteNotifications(options)
    }

    func silentAuthorization() {
        let options: UNAuthorizationOptions =  [.provisional]
        registerForRemoteNotifications(options)
    }
}

// MARK: Remote Notifications

extension PushManager: @preconcurrency RemoteNotificationsInterface {

    @MainActor func didRegisterForRemoteNotificationsWithDeviceToken(
        _ token: Data
    ) {
        Task(priority: .low) {
            let tokenString = token.reduce("", {$0 + String(format: "%02x", $1)})
            await logger.debug(.text("APNS: \(tokenString)"))
        }
    }

    @MainActor func didFailToRegisterForRemoteNotificationsWithError(
        _ error: any Error
    ) {
        Task(priority: .low) {
            await logger.debug(.error(error))
        }
    }

    @MainActor func didReceiveRemoteNotification(
        _ userInfo: [AnyHashable : Any]
    ) {
        nonisolated(unsafe) let info = userInfo
        Task(priority: .high) {
            await pushHandler(info)
        }
    }
}

// MARK: - User Notification Center

extension PushManager: @preconcurrency UserNotificationCenterInterface {

    @MainActor func willPresent(
        _ notification: UNNotification
    ) {
        nonisolated(unsafe) let info = notification.request.content.userInfo
        Task(priority: .high) {
            await pushHandler(info)
        }
    }
}

// MARK: - Private

private extension PushManager {

    func pushHandler(
        _ userInfo: [AnyHashable : Any]
    ) {
        if let smsCode = userInfo["smsCode"] as? String {
            NotificationCenter.default.post(name: NSNotification.Name("SMSCodeReceived"), object: smsCode)
        }
    }

    func registerForRemoteNotifications(
        _ options: UNAuthorizationOptions
    ) {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: options
            ) { [weak self] allowed, error in
                if allowed {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
                if let error = error {
                    guard let self else { return }
                    Task(priority: .low) {
                        await self.logger.remoteAndDebug(.error(error))
                    }
                }
            }
    }
}
