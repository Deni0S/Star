protocol AppManagersInterface: Sendable {
    var analytic: AnalyticInterface { get }
    var authorization: AuthorizationInterface { get }
    var logging: LoggingInterface { get }
    var push: PushInterface { get }
    var settings: SettingsInterface { get }
}

struct AppManagers: AppManagersInterface {
    let analytic: AnalyticInterface
    let authorization: AuthorizationInterface
    let logging: LoggingInterface
    let push: PushInterface
    let settings: SettingsInterface
}
