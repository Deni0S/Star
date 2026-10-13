import SwiftUI

final class PhoneRequestViewModel: ObservableObject {

    @Binding var nextStep: String

    private let authirizationHandlers: AuthorizationInterface

    @Published private(set) var currentPhoneNumber = ""

    let phoneMask = NSLocalizedString("11", comment: "")

    var isValidCurrentPhoneNumber: Bool {
        currentPhoneNumber.count == phoneMask.count
    }

    init(
        authirizationHandlers: AuthorizationInterface,
        nextStep: Binding<String>
    ) {
        self.authirizationHandlers = authirizationHandlers
        self._nextStep = nextStep
    }

    @MainActor func codeRequest() {
        Task(priority: .userInitiated) {
            await authirizationHandlers.codeRequest(currentPhoneNumber)
            nextStep = currentPhoneNumber
        }
    }

    func validation(
        _ text: String
    ) {
        DispatchQueue.main.async {
            UISelectionFeedbackGenerator().selectionChanged()
        }

        let numbers = text.replacingOccurrences(
            of: "[^0-9]",
            with: "",
            options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for char in phoneMask where index < numbers.endIndex {
            if char == "#" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(char)
            }
        }

        currentPhoneNumber = result
    }
}
