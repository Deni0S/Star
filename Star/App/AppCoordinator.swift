import SwiftUI

// MARK: - Interfaces

protocol AppSceneHandlers: Sendable {
    /// Process the current phase of the scene's lifecycle
    func scenePhase(_ value: ScenePhase) async
}

protocol AppLifecycleInterface {
    /// Launch process is almost done and the app is almost ready to run
    func didFinishLaunchingWithOptions()
}

protocol Configurable: Sendable {
    /// Build a configuration
    func configure() async
}

// MARK: - App Coordinator

final actor AppCoordinator: ObservableObject {

    let managers: AppManagersInterface

    static let shared = AppCoordinator()

    private init() {
        let loggingManager = LoggingManager()
        let settingsManager = SettingsManager()
        Task(priority: .high) {
            await settingsManager.configure()
        }
        let analyticManager = AnalyticManager()
        let pushManager = PushManager(
            logger: loggingManager)
        let authorizationManager = AuthorizationManager(
            loger: loggingManager)

        self.managers = AppManagers(
            analytic: analyticManager,
            authorization: authorizationManager,
            logging: loggingManager,
            push: pushManager,
            settings: settingsManager)
    }
}

// MARK: - App Lifecycle

extension AppCoordinator: @preconcurrency AppLifecycleInterface {

    @MainActor func didFinishLaunchingWithOptions() {
        Task(priority: .high) {
            await managers.push.silentAuthorization()
            await managers.analytic.requestTrackingAuthorization()
        }
    }
}

// MARK: - App Scene Handlers

extension AppCoordinator: @preconcurrency AppSceneHandlers {

    func scenePhase(
        _ value: ScenePhase
    ) async {
        switch value {
        case .active:
            Task(priority: .high) {
                await managers.settings.configure()
            }
        case .inactive:
            break
        case .background:
            break
        @unknown default:
            break
        }
    }
}
