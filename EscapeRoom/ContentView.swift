import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        
        VStack{
            
        }
//        RealityView { content in
//            // Add the initial RealityKit content
//            //            if let scene = try? await Entity(named: "computer", in: realityKitContentBundle) {
//            //                scene.scale *= [0.1, 0.1, 0.1]
//            //                content.add(scene)
//            //            }
//        } update: { content in
//            // Update the RealityKit content when SwiftUI state changes
//            //            if let scene = content.entities.first {
//            //                let uniformScale: Float = enlarge ? 1.4 : 1.0
//            //                scene.transform.scale = [uniformScale, uniformScale, uniformScale]
//            //            }
//            
//           
//            
//       
//            
//        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomOrnament) {
                VStack (spacing: 12) {
//                    Button {
//                        appModel.switchScreen.toggle()
//                        print("switchScreen: \(appModel.switchScreen)")
//                    } label: {
//                        Text("Change screen")
//                    }
                    ToggleImmersiveSpaceButton()
                }
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
        .environment(AppModel())
}
