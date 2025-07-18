import SwiftUI

// MARK: - Interfaces

typealias LoggingInterface = Sendable & LoggingSendingInterface

protocol LoggingSendingInterface: Sendable {
    /// Local error logging for debugging
    func debug(_ type: LoggingManager.ErrorType) async
    /// Remote error logging for monitoring purposes
    func remote(_ type: LoggingManager.ErrorType) async
    /// Remote for monitoring purposes and Local for debugging
    func remoteAndDebug(_ type: LoggingManager.ErrorType) async
}

// MARK: - Logging Manager

final actor LoggingManager {

    struct MetaData {
        let file: String
        let function: String
        let line: Int
    }

    enum ErrorType {
        case text(_ value: String, file: String = #file, function: String = #function, line: Int =  #line)
        case error(_ value: Error, file: String = #file, function: String = #function, line: Int =  #line)
        case errorCode(_ value: Error, _ code: Int, file: String = #file, function: String = #function, line: Int =  #line)

        var text: String {
            switch self {
            case let .text(value,_,_,_):
                return value
            case let .error(value,_,_,_):
                return "\(value.localizedDescription), Code: \((value as NSError).code)"
            case let .errorCode(value, code,_,_,_):
                return "\(value.localizedDescription), Code: \(code)"
            }
        }

        var meta: MetaData {
            switch self {
            case let .text(_,file,function,line),
                let .error(_,file,function,line),
                let .errorCode(_,_,file,function,line):
                return MetaData(file: file, function: function, line: line)
            }
        }
    }
}

// MARK: - Logging Sending

extension LoggingManager: LoggingSendingInterface {

    func debug(
        _ type: ErrorType
    ) async {
        print("\(type.text.isEmpty ? "" : "🛠️ \(type.text) *\n")" +
              "🛠️ \(type.meta.file.split(separator: "/").last?.split(separator: ".").first ?? "") -> \(type.meta.line) -> \(type.meta.function) *")

        #if DEBUG || ADHOC
        if let isShowErrors = UserDefaults.standard.value(forKey: SettingsKeys.showErrors.rawValue) as? Bool {
            if isShowErrors {
                await showToast(type)
            }
        } else {
            let textError = "🛠️ The value was not set: \(SettingsKeys.showErrors.rawValue) *"
            print(textError)
            Task(priority: .high) {
                await showToast(.text(textError))
            }
            Task(priority: .low) {
                await remote(.text(textError))
            }
        }
        #endif
    }

    func remote(
        _ type: ErrorType
    ) async {
        DispatchQueue.global(qos: .background).async {
            #if !targetEnvironment(simulator)
            #if RELEASE
            // TODO: Send error to remote release tracer
            #endif
            #if ADHOC
            // TODO: Send error to remote debug tracer
            #endif
            #endif
        }
    }

    func remoteAndDebug(
        _ type: ErrorType
    ) async {
        Task {
            await remote(type)
        }
        Task {
            await debug(type)
        }
    }
}

// MARK: - Private

private extension LoggingManager {

    #if DEBUG || ADHOC
    func showToast(
        _ type: ErrorType
    ) async {
        // TODO: Show error toast
    }
    #endif
}
