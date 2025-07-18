import SwiftUI

struct StarButtonView: View {

    enum StateType {
        case disabled
        case active
        case loading
    }

    let text: String

    @Binding var type: StateType

    var action: () -> Void

    var body: some View {
        Button {
            withAnimation {
                type = .loading
            }
            action()
        } label: {
            HStack {
                Spacer()
                if type == .loading {
                    ProgressView()
                        .tint(Color.customAccent)
                } else {
                    Text(text)
                        .font(Font.custom("Nunito-Bold", size: 18))
                        .foregroundColor(
                            type == .disabled ? .customADB1BCADB1BC : .customFFFFFFFFFFFF
                        )
                }
                Spacer()
            }
        }
        .frame(height: 48)
        .background(type == .active ? Color.customAccent : Color.customEBEBEBEBEBEB)
        .cornerRadius(10)
        .disabled(type != .active)
    }
}

#Preview {
    StarButtonView(
        text: NSLocalizedString("3", comment: ""),
        type: .constant(.active),
        action: {})
    .padding([.leading, .trailing], 20)
}
