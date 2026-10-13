import SwiftUI

@main
struct AppScene: App {

    enum ScreenType: Sendable {
        case auth
        case main
    }

    @UIApplicationDelegateAdaptor(AppDelegates.self) private var appDelegate

    @Environment(\.scenePhase) private var scenePhase

    private var handlers: AppSceneHandlers = AppCoordinator.shared

    @State private var sceneScreen: ScreenType = .auth
    @State private var authorized = false
    @State private var unauthorized = false
    @State private var showLaunchScreen = true

    @Namespace private var star

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showLaunchScreen {
                    AppLaunchScreenView(
                        star: star)
                } else {
                    switch sceneScreen {
                    case .auth:
                        AuthorizationAssembly()
                            .build(
                                star: star,
                                authorized: $authorized)
                            .statusBar(hidden: false)
                    case .main:
                        StarMainAssembly()
                            .build(unauthorized: $unauthorized)
                            .statusBar(hidden: false)
                    }
                }
            }
            .statusBar(hidden: true)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showLaunchScreen = false
                }
            }
            .animation(.bouncy, value: showLaunchScreen)
            .animation(.bouncy, value: sceneScreen)
        }
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.verticalSizeClass, .compact)
        .onChange(of: scenePhase) { value in
            Task(priority: .high) {
                await handlers.scenePhase(value)
            }
        }
        .onChange(of: authorized) { _ in
            sceneScreen = .main
        }
        .onChange(of: unauthorized) { _ in
            sceneScreen = .auth
        }
    }
}
