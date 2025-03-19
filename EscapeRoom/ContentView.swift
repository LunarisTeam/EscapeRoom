import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        
        ToggleImmersiveSpaceButton()
    }
}
