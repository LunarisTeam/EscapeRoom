import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    @State private var translationx: Float = 0
    @State private var translationy: Float = 0
    @State private var translationz: Float = 0
    @State private var rotationx: Float = 0
    @State private var rotationy: Float = 0
    @State private var rotationz: Float = 0
    @State private var angle: Float = 0
    
    var body: some View {
        VStack{
            ToggleImmersiveSpaceButton()
            
            if appModel.immersiveSpaceState == .open {
                Form {
                    Section("Translation"){
                        HStack {
                            Text("Translate on x")
                                .font(.title)
                            Slider(value: $translationx, in: -10...10)
                                .onChange(of: translationx) {
                                    appModel.translation.x = translationx
                                }
                            Text("\(translationx)")
                                .font(.title)
                        }
                        
                        HStack {
                            Text("Translate on y")
                                .font(.title)
                            Slider(value: $translationy, in: -10...10)
                                .onChange(of: translationy) {
                                    appModel.translation.y = translationy
                                }
                            Text("\(translationy)")
                                .font(.title)
                        }
                        
                        HStack {
                            Text("Translate on z")
                                .font(.title)
                            Slider(value: $translationz, in: -10...10)
                                .onChange(of: translationz) {
                                    appModel.translation.z = translationz
                                }
                            Text("\(translationz)")
                                .font(.title)
                        }
                    }
                    
                    Section("Rotation") {
                        
                        HStack {
                            Text("Rotate on x")
                                .font(.title)
                            Slider(value: $rotationx, in: -10...10)
                                .onChange(of: rotationx) {
                                    appModel.rotation.vector.x = rotationx
                                }
                            Text("\(rotationx)")
                                .font(.title)
                        }
                        
                        HStack {
                            Text("Rotate on y")
                                .font(.title)
                            Slider(value: $rotationy, in: -10...10)
                                .onChange(of: rotationy) {
                                    appModel.rotation.vector.y = rotationy
                                }
                            Text("\(rotationy)")
                                .font(.title)
                        }
                        
                        HStack {
                            Text("Rotate on z")
                                .font(.title)
                            Slider(value: $rotationz, in: -10...10)
                                .onChange(of: rotationz) {
                                    appModel.rotation.vector.z = rotationz
                                }
                            Text("\(rotationz)")
                                .font(.title)
                        }
                    }
                    
                    
                }
                
                Button {
                    appModel.translation = [0,0,0]
                    appModel.rotation.vector = [0,0,0,0]
                } label: {
                    Text("Reset")
                }
                
                Button {
                    appModel.bookAnchor.toggle()
                } label: {
                    appModel.bookAnchor ? Text("Disable book anchor") : Text("Enable book anchor")
                }
                
                
            }
            
            
            
            
            
            
            
        }.padding(.vertical, 20)
            .frame(width: 800)
        
    }
}

#Preview {
    ContentView()
        .environment(AppModel())
}
