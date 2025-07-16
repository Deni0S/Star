import SwiftUI

// MARK: - AppDelegates

final class AppDelegates: NSObject, ObservableObject {

    private let lifecycleDelegate: AppLifecycleInterface = AppCoordinator.shared
    private let remoteNotificationsDelegate: RemoteNotificationsInterface = AppCoordinator.shared.managers.push
    private let userNotificationCenterDelegate: UserNotificationCenterInterface = AppCoordinator.shared.managers.push

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - ApplicationDelegate

extension AppDelegates: UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        lifecycleDelegate.didFinishLaunchingWithOptions()
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        remoteNotificationsDelegate.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        remoteNotificationsDelegate.didFailToRegisterForRemoteNotificationsWithError(error)
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        remoteNotificationsDelegate.didReceiveRemoteNotification(userInfo)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegates: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        userNotificationCenterDelegate.willPresent(notification)
    }
}
