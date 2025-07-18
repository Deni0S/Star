import AppTrackingTransparency
import StoreKit
import SwiftUI

// MARK: - Interfaces

typealias AnalyticInterface = Sendable & TrackingInterface

protocol TrackingInterface {
    /// Request to receive IDFA
    func requestTrackingAuthorization() async
}

// MARK: - Analytic Manager

final actor AnalyticManager {

}

// MARK: - Tracking

extension AnalyticManager: TrackingInterface {

    func requestTrackingAuthorization() async {
        await ATTrackingManager.requestTrackingAuthorization()
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .notDetermined:
            SKAdNetwork.registerAppForAdNetworkAttribution()
        default:
            break
        }
    }
}
