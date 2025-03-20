//
//  AppModel.swift
//  EscapeRoom
//
//  Created by Marzia Pirozzi on 18/03/25.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "Scene"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    var translation: SIMD3<Float> = .init(0, 0, 0)
    var rotation: simd_quatf = .init(angle: .zero, axis: .init(x: 0, y: 0, z: 0))
    var bookAnchor: Bool = true
}
