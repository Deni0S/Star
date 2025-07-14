import SwiftUI

@main
struct AppScene: App {

    @UIApplicationDelegateAdaptor(AppDelegates.self) private var appDelegate

    @Environment(\.scenePhase) private var scenePhase

    private var handlers: AppSceneHandlers = AppCoordinator.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .statusBar(hidden: false)
        }
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
        .onChange(of: scenePhase) { value in
            Task(priority: .high) {
                await handlers.scenePhase(value)
            }
        }
    }
}
