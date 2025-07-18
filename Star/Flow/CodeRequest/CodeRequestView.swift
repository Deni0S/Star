import SwiftUI

struct CodeRequestView: View {

    @ObservedObject var viewModel: CodeRequestViewModel

    @State private var buttonType: StarButtonView.StateType = .disabled
    @State private var fieldText = ""
    @State private var currentCode = ""

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
                    Image("StarWinkingIcon")
                        .matchedGeometryEffect(id: "MatchedStar", in: star)
                    Spacer()

                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("1", comment: ""))
                            .font(Font.custom("Nunito-Bold", size: 28))
                            .foregroundColor(.custom313C58313C58)
                            .multilineTextAlignment(.center)
                            .padding(.top, 24)

                        Group {
                            Text("\(NSLocalizedString("2", comment: ""))")
                                .font(Font.custom("Nunito-Medium", size: 16))
                            + Text(" \(viewModel.phoneNumber)")
                                .font(Font.custom("Nunito-Bold", size: 16))
                        }
                        .foregroundColor(.custom313C58313C58)
                        .lineLimit(3)
                        .padding(.top, 14)

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
                            HStack(alignment: .center) {
                                ForEach(0..<5, id: \.self) { index in
                                    Text("\(viewModel.currentCode[index])")
                                        .font(Font.custom("Nunito-Bold", size: 14))
                                        .foregroundColor(.custom313C58313C58)
                                        .frame(width: 56, height: 48)
                                        .overlay(RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.customD7DAE3D7DAE3, lineWidth: 1))
                                    if index != 4 {
                                        Spacer()
                                    }
                                }
                            }

                            TextField("", text: $fieldText)
                                .foregroundColor(.clear)
                                .tint(.clear)
                                .background(Color.clear)
                                .padding(.leading, 16)
                                .frame(height: 48)
                                .keyboardType(.numberPad)
                                .textContentType(.oneTimeCode)
                        }

                        StarButtonView(
                            text: NSLocalizedString("3", comment: ""),
                            type: $buttonType
                        ) {
                            viewModel.authRequest()
                        }
                        .padding(.top, 14)

                        if viewModel.showError {
                            ZStack {
                                Color.customE44724E44724
                                HStack {
                                    Text("\(NSLocalizedString("6", comment: ""))")
                                        .font(Font.custom("Nunito-Bold", size: 16))
                                        .foregroundColor(.customFFFFFFFFFFFF)
                                        .padding(.leading, 16)
                                    Spacer()
                                }
                            }
                            .frame(height: 48)
                            .padding(.top, 40)
                            .padding([.leading, .trailing], -20)
                            .onAppear {
                                buttonType = .disabled
                            }
                        }

                        HStack {
                            Spacer()
                            HStack(spacing: 8) {
                                Text("\(viewModel.currentTime)")
                                    .font(Font.custom("Nunito-Bold", size: 16))
                                    .foregroundColor(.custom677392677392)
                                Text("\(NSLocalizedString("7", comment: ""))")
                                    .font(Font.custom("Nunito-Bold", size: 16))
                                    .foregroundColor(.customAccent)
                                    .opacity(viewModel.currentTime.isEmpty ? 1 : 0.4)
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 30 + geometry.safeAreaInsets.bottom)
                            .onTapGesture {
                                viewModel.codeRequest()
                            }
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
            .onChange(of: fieldText) { text in
                if text.count > viewModel.currentCode.count {
                    fieldText = String(text.dropLast(1))
                }
                viewModel.updateCurrentCode(fieldText)
            }
            .onChange(of: viewModel.currentCode) { _ in
                buttonType = viewModel.isValidCurrentCode ? .active : .disabled
            }
            .onChange(of: viewModel.clearText) { _ in
                fieldText = ""
            }
            .onChange(of: viewModel.chekUpdate) { _ in
                fieldText = viewModel.smsCode
            }
        }
    }
}

struct CodeRequestView_Previews: PreviewProvider {
    @Namespace static var mockStar
    static var previews: some View {
        CodeRequestAssembly().build(
            star: mockStar,
            phoneNumber: "+7 (800) 777-00-00",
            nextStep: .constant(false))
    }
}
