//
//  EscapeRoomApp.swift
//  EscapeRoom
//
//  Created by Marzia Pirozzi on 18/03/25.
//

import SwiftUI

@main
struct EscapeRoomApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        .defaultSize(width: 20, height: 10, depth: 0, in: .centimeters)
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
