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

// MARK: - AppCoordinator

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

        self.managers = AppManagers(
            analytic: analyticManager,
            logging: loggingManager,
            push: pushManager,
            settings: settingsManager)
    }
}

// MARK: - AppLifecycleDelegate

extension AppCoordinator: @preconcurrency AppLifecycleInterface {

    @MainActor func didFinishLaunchingWithOptions() {
        Task(priority: .high) {
            await managers.push.silentAuthorization()
            await managers.analytic.requestTrackingAuthorization()
        }
    }
}

// MARK: - AppSceneHandlers

extension AppCoordinator: AppSceneHandlers {

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
