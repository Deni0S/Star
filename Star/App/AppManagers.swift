protocol AppManagersInterface: Sendable {
    var analytic: AnalyticInterface { get }
    var logging: LoggingInterface { get }
    var push: PushInterface { get }
    var settings: SettingsInterface { get }
}

struct AppManagers: AppManagersInterface {
    let analytic: AnalyticInterface
    let logging: LoggingInterface
    let push: PushInterface
    let settings: SettingsInterface
}
