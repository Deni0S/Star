protocol AppManagersInterface: Sendable {
    var logging: LoggingInterface { get }
    var push: PushInterface { get }
    var settings: SettingsInterface { get }
}

struct AppManagers: AppManagersInterface {
    let logging: LoggingInterface
    let push: PushInterface
    let settings: SettingsInterface
}
