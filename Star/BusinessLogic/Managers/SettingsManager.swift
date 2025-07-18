import SwiftUI

// MARK: - Interfaces

typealias SettingsInterface = Sendable & Configurable

// MARK: - Settings Keys

#if RELEASE
enum SettingsKeys: String {
    case settingsBundle = "Settings.bundle"
}
#endif

#if DEBUG || ADHOC
enum SettingsKeys: String {
    case settingsBundle = "DebugSettings.bundle"
    case showErrors = "debug_setting_show_errors"
}
#endif

// MARK: - Settings Manager

final actor SettingsManager {

    private var saveInfoTask: Task<(), Never>?
}

// MARK: - Configurable

extension SettingsManager: Configurable {

    func configure() async {
        saveInfoTask?.cancel()

        saveInfoTask = Task {
            guard let url = Bundle.main.url(
                forResource: "Root",
                withExtension: "plist",
                subdirectory: SettingsKeys.settingsBundle.rawValue),
                  let settings = NSDictionary(contentsOf: url) as? [String: Any],
                  let preferences = settings["PreferenceSpecifiers"] as? [[String: Any]]
            else { return }

            let info: [String: Any] = preferences.reduce(into: [:]) { (result, specifiers) in
                guard let key = specifiers["Key"] as? String,
                      let value = specifiers["DefaultValue"]
                else { return }
                result[key] = value
            }

            UserDefaults.standard.register(defaults: info)
            UserDefaults.standard.synchronize()
        }
    }
}
