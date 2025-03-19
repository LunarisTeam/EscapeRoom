//
//  ImmersiveView.swift
//  EscapeRoom
//
//  Created by Marzia Pirozzi on 18/03/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @Observable
    final class StateManager {
        var myTexture: TextureResource? = nil
        var sceneModel: Entity? = nil
        var schermoModel: Entity? = nil
    }
    
    @Environment(AppModel.self) private var appModel
    
    @State private var stateManager = StateManager()
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Scene", in: realityKitContentBundle),
               let schermo = immersiveContentEntity.findEntity(named: "Schermo") as? ModelEntity {
                self.stateManager.sceneModel = immersiveContentEntity
                self.stateManager.schermoModel = schermo
                content.add(immersiveContentEntity)
                
//                print("found schermo")
//                if let texture = try? TextureResource.load(named: "Captcha1") {
//                    print("found image")
//                    print("texture found: \(texture)")
//                    
//                    self.stateManager.myTexture = texture
//                    print("my texture: \(self.stateManager.myTexture)")
//                }
                
            }
            
            
        }update: {content in
            
            guard let texture = self.stateManager.myTexture,
                  let schermoModel = self.stateManager.schermoModel else { return }
            
            if(appModel.switchScreen){
                print("inside if")
                var material = SimpleMaterial()
                material.color = .init(tint: .white, texture: .init(texture))
                print("modified material color")
                
                if var modelComponent = schermoModel.components[ModelComponent.self] {
                    print("copied component")
                    modelComponent.materials.removeAll()
                    print("removed all material")
                    modelComponent.materials = [material]
                    print("added material")
                    schermoModel.components[ModelComponent.self] = modelComponent
                    print("assigned material")
                    //content.add(schermoModel)
                }
            }
            
            
        }.gesture(
            SpatialTapGesture()
//                .targetedToAnyEntity()
                .targetedToEntity(where: .has(InputTargetComponent.self))
                .onEnded {
                    $0.entity.applyTapForBehaviors()
                    if($0.entity.name == "Cylinder_002"){
                        
                        appModel.switchScreen.toggle()
                    }
                })
    }
    
}
