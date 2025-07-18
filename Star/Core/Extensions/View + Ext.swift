import Combine
import SwiftUI

extension View {

    func cornerRadiusSplit(
        _ radius: CGFloat,
        corners: UIRectCorner
    ) -> some View {
        clipShape(SplitCorner(radius: radius, corners: corners))
    }
}
