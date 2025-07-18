import Combine
import SwiftUI

final class CodeRequestViewModel: ObservableObject {

    @Binding var nextStep: Bool

    private let authirizationHandlers: AuthorizationHandlersInterface

    @Published private(set) var currentCode = [String](repeating: "", count: 5)
    @Published private(set) var clearText = false
    @Published private(set) var chekUpdate = false
    @Published private(set) var showError = false
    @Published private(set) var currentTime = ""
    @Published private(set) var authLoading = false

    private let lock = NSLock()
    private var cancellable: Cancellable?
    private let timer = Timer.publish(every: 1, on: .main, in: .default)
    private var waitTime = 0

    var isValidCurrentCode: Bool {
        currentCode.reduce("", +).count == currentCode.count
    }

    private(set) var smsCode: String = ""
    let phoneNumber: String

    init(
        authirizationHandlers: AuthorizationHandlersInterface,
        phoneNumber: String,
        nextStep: Binding<Bool>
    ) {
        self.authirizationHandlers = authirizationHandlers
        self.phoneNumber = phoneNumber
        self._nextStep = nextStep

        addObserver()
        setupTimer()
    }

    deinit {
        cancellable?.cancel()
    }

    @MainActor func authRequest() {
        if !authLoading {
            authLoading = true
            Task(priority: .userInitiated) {
                let isValid = await authirizationHandlers.checkSmsCode(currentCode.reduce("", +))
                UIApplication.shared.endEditing()
                if isValid {
                    nextStep.toggle()
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                    showError = true
                    authLoading = false
                }
            }
        }
    }

    @MainActor func codeRequest() {
        guard waitTime <= 0 else { return }
        showError = false

        setupTimer()
        Task(priority: .userInitiated) {
            await authirizationHandlers.codeRequest(phoneNumber)
        }
    }

    func updateCurrentCode(
        _ text: String
    ) {
        DispatchQueue.main.async {
            UISelectionFeedbackGenerator().selectionChanged()
        }

        showError = false

        if text.count < currentCode.reduce("", +).count {
            lock.lock()
            currentCode = [String](repeating: "", count: 5)
            clearText.toggle()
            lock.unlock()
            return
        }

        for (index, char) in text.enumerated() {
            guard index <= currentCode.count - 1  else {
                break
            }
            lock.lock()
            currentCode[index] = String(char)
            lock.unlock()
        }
    }
}

// MARK: - Private

private extension CodeRequestViewModel {

    func addObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("SMSCodeReceived"),
            object: nil,
            queue: .main
        ) { [weak self] note in
            if let code = note.object as? String {
                Task { @MainActor  in
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    self?.smsCode = code
                    self?.chekUpdate.toggle()
                }
            }
        }
    }

    func setupTimer() {
        cancellable?.cancel()
        waitTime = 30
        cancellable = timer.autoconnect().sink { [weak self] _ in
            guard let self else { return }
            if waitTime > 0 {
                currentTime = "00:\(waitTime <= 9 ? "0" : "" )\(waitTime)"
                waitTime -= 1
            } else {
                currentTime = ""
                cancellable?.cancel()
            }
        }
    }
}
