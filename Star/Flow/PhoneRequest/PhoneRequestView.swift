import SwiftUI

struct PhoneRequestView: View {

    @ObservedObject var viewModel: PhoneRequestViewModel

    @State private var buttonType: StarButtonView.StateType = .disabled
    @State private var maskedPhoneNumber = ""
    @State private var fieldText = ""

    var star: Namespace.ID

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.customAccent

                Image("BackgroundStarSmallIcon")
                    .resizable()
                    .matchedGeometryEffect(id: "MatchedBackground", in: star)
                    .frame(width: geometry.size.width)
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    Image(viewModel.currentPhoneNumber.isEmpty ? "StarForwardIcon" : "StarSleepingIcon")
                        .matchedGeometryEffect(id: "MatchedStar", in: star)
                    Spacer()

                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("1", comment: ""))
                            .font(Font.custom("Nunito-Bold", size: 28))
                            .foregroundColor(.custom313C58313C58)
                            .multilineTextAlignment(.center)
                            .padding(.top, 24)

                        HStack(spacing: 4) {
                            Text(NSLocalizedString("9", comment: ""))
                                .foregroundColor(.custom677392677392)
                                .font(Font.custom("Nunito-Bold", size: 14))
                            Text("*")
                                .foregroundColor(.customADB1BCADB1BC)
                                .font(Font.custom("Inter_18pt-Regular", size: 14))
                        }
                        .padding(.top, 14)

                        ZStack {
                            TextField("", text: $maskedPhoneNumber)
                                .font(Font.custom("Nunito-Bold", size: 16))
                                .foregroundColor(.custom313C58313C58)
                                .tint(.clear)
                                .padding(.leading, 16)
                                .frame(height: 48)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.customD7DAE3D7DAE3, lineWidth: 1))
                                .keyboardType(.numberPad)
                                .textContentType(.oneTimeCode)
                                .disabled(true)

                            let hint = "+7"
                            TextField(hint, text: $fieldText)
                                .placeholder(
                                    when: fieldText.isEmpty
                                ) {
                                    Text(hint)
                                        .foregroundColor(.customADB1BCADB1BC)
                                }
                                .foregroundColor(.clear)
                                .tint(.clear)
                                .background(Color.clear)
                                .padding(.leading, 16)
                                .frame(height: 48)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.clear, lineWidth: 1))
                                .keyboardType(.numberPad)
                                .textContentType(.oneTimeCode)
                        }

                        StarButtonView(
                            text: NSLocalizedString("3", comment: ""),
                            type: $buttonType
                        ) {
                            UIApplication.shared.endEditing()
                            viewModel.codeRequest()
                        }
                        .padding(.top, 14)

                        HStack {
                            Spacer()
                            HStack(spacing: 8) {
                                Text("\(NSLocalizedString("4", comment: ""))")
                                    .font(Font.custom("Nunito-Bold", size: 16))
                                    .foregroundColor(.custom677392677392)
                                Text("[\(NSLocalizedString("5", comment: ""))](https://www.apple.com).")
                                    .font(Font.custom("Nunito-Bold", size: 16))
                                    .foregroundColor(.customAccent)
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 30 + geometry.safeAreaInsets.bottom)
                            Spacer()
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    .background(Color.customFFFFFF000000)
                    .cornerRadiusSplit(20, corners: [.topLeft, .topRight])
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
            .background(Color.customAccent)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.bouncy, value: buttonType)
            .animation(.bouncy(duration: 0.5), value: viewModel.currentPhoneNumber)
            .onChange(of: fieldText) { text in
                if text.count > 11 {
                    fieldText = String(text.dropLast(1))
                }
                if !(fieldText < viewModel.currentPhoneNumber) {
                    guard text.count > 1 || text == "7" else {
                        fieldText = text == "8" ? "7" : "7\(text)"
                        return
                    }
                }
                viewModel.validation(text)
            }
            .onChange(of: viewModel.currentPhoneNumber) { phoneNumber in
                maskedPhoneNumber = phoneNumber
                buttonType = viewModel.isValidCurrentPhoneNumber ? .active : .disabled
            }
        }
    }
}

struct PhoneRequestView_Previews: PreviewProvider {
    @Namespace static var mockStar
    static var previews: some View {
        PhoneRequestAssembly().build(
            star: mockStar,
            nextStep: .constant(""))
    }
}
