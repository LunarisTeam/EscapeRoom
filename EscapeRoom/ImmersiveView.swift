//
//  ImmersiveView.swift
//  EscapeRoom
//
//  Created by Marzia Pirozzi on 18/03/25.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct ImmersiveView: View {
    
    @Observable
    final class StateManager {
        var textures: [TextureResource?] = []
        var sceneModel: Entity? = nil
        var schermoModel: Entity? = nil
        var loadedTexture: TextureResource? = nil
        var changeScreen: Bool = false
        var startCaptchas: Bool = false
        var counter: Int = 1
        var bookModel: Entity? = nil
        var handAnchor: AnchorEntity? = nil
    }
    
    @Environment(AppModel.self) private var appModel
    @State var session: SpatialTrackingSession?
    
    @State private var stateManager = StateManager()
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Scene", in: realityKitContentBundle),
               let schermo = immersiveContentEntity.findEntity(named: "Schermo") as? ModelEntity {
                self.stateManager.sceneModel = immersiveContentEntity
                self.stateManager.schermoModel = schermo
                
                content.add(immersiveContentEntity)
                loadTextures()
            }
            
            let session = SpatialTrackingSession()
            let configuration = SpatialTrackingSession.Configuration(tracking: [.hand])
            _ = await session.run(configuration)
            self.session = session
            
            
            //Setup an anchor at the user's right palm.
            stateManager.handAnchor = AnchorEntity(.hand(.left, location: .palm), trackingMode: .continuous)
            
            //Add the Gauntlet scene that was set up in Reality Composer Pro.
            if let bookEntity = try? await Entity(named: "booknoteFinal", in: realityKitContentBundle) {
                
                stateManager.bookModel = bookEntity
                
                
            }
            
            if let entity = stateManager.sceneModel?.findEntity(named: "Mug_Cylinder_013_Cylinder_007_001"){
                print("child: \(entity.name)")
                if(entity.components.has(InputTargetComponent.self)){
                    entity.components.set(HoverEffectComponent(.spotlight(
                        HoverEffectComponent.SpotlightHoverEffectStyle(
                            color: .yellow, strength: 3.0
                        )
                    )))
                }
            }
            
            if let entity = stateManager.sceneModel?.findEntity(named: "Cylinder_002"){
                print("child: \(entity.name)")
                if(entity.components.has(InputTargetComponent.self)){
                    entity.components.set(HoverEffectComponent(.spotlight(
                        HoverEffectComponent.SpotlightHoverEffectStyle(
                            color: .yellow, strength: 2.0
                        )
                    )))
                }
            }
            
            if let entity = stateManager.sceneModel?.findEntity(named: "Cylinder_003"){
                print("child: \(entity.name)")
                if(entity.components.has(InputTargetComponent.self)){
                    entity.components.set(HoverEffectComponent(.spotlight(
                        HoverEffectComponent.SpotlightHoverEffectStyle(
                            color: .yellow, strength: 2.0
                        )
                    )))
                }
            }
            
            if let entity = stateManager.sceneModel?.findEntity(named: "Cylinder_005"){
                print("child: \(entity.name)")
                if(entity.components.has(InputTargetComponent.self)){
                    entity.components.set(HoverEffectComponent(.spotlight(
                        HoverEffectComponent.SpotlightHoverEffectStyle(
                            color: .yellow, strength: 2.0
                        )
                    )))
                }
            }
            
            
        }update: {content in
            
            
            if(appModel.bookAnchor){
                //                    Child the gauntlet scene to the handAnchor
                stateManager.handAnchor!.addChild(stateManager.bookModel!)
                
                //                     Add the handAnchor to the RealityView scene.
                content.add(stateManager.handAnchor!)
            }else{
                content.remove(stateManager.handAnchor!)
            }
            
            stateManager.sceneModel!.transform.translation = appModel.translation
            stateManager.sceneModel!.transform.rotation = appModel.rotation
            
            if(stateManager.startCaptchas){
                
                guard let texture = stateManager.textures[0],
                      let schermoModel = stateManager.schermoModel else { return }
                
                stateManager.loadedTexture = texture
                
                var material = SimpleMaterial()
                material.color = .init(tint: .white, texture: .init(texture))
                //print("modified material color")
                
                if var modelComponent = schermoModel.components[ModelComponent.self] {
                    // print("copied component")
                    modelComponent.materials.removeAll()
                    // print("removed all material")
                    modelComponent.materials = [material]
                    // print("added material")
                    schermoModel.components[ModelComponent.self] = modelComponent
                    //  print("assigned material")
                }
                
                stateManager.startCaptchas = false
            }
            
            if(stateManager.changeScreen == true && stateManager.loadedTexture != nil && stateManager.counter < stateManager.textures.count){
                
                //get next texture
                guard let texture = stateManager.textures[stateManager.counter],
                      let schermoModel = stateManager.schermoModel else { return }
                
                stateManager.loadedTexture = texture
                
                var material = SimpleMaterial()
                material.color = .init(tint: .white, texture: .init(texture))
                // print("modified material color")
                
                if var modelComponent = schermoModel.components[ModelComponent.self] {
                    //  print("copied component")
                    modelComponent.materials.removeAll()
                    //  print("removed all material")
                    modelComponent.materials = [material]
                    //  print("added material")
                    schermoModel.components[ModelComponent.self] = modelComponent
                    //  print("assigned material")
                }
                
                stateManager.changeScreen = false
                stateManager.counter += 1
            }
            
            
            
            
        }.installGestures()
        
        //.upperLimbVisibility(.hidden)
        
            .gesture(
                SpatialTapGesture()
                    .targetedToEntity(where: .has(InputTargetComponent.self))
                    .onEnded {
                        $0.entity.applyTapForBehaviors()
                        if($0.entity.name == "Cylinder_002" && stateManager.loadedTexture == nil){
                            // print("started captchas")
//                            print(stateManager.startCaptchas)
                            stateManager.startCaptchas = true
//                            print(stateManager.startCaptchas)
                        }
                        
                        if(stateManager.loadedTexture != nil){
                            stateManager.changeScreen = true
                        }
                    })
    }
    
    
    
    
    
    func loadTextures (){
        if let texture = try? TextureResource.load(named: "Captcha1") {
            //print("texture1 found")
            stateManager.textures.append(texture)
        }
        if let texture = try? TextureResource.load(named: "Captcha1Wrong") {
            // print("texture1Wrong found")
            stateManager.textures.append(texture)
        }
        if let texture = try? TextureResource.load(named: "Captcha2") {
            // print("texture2 found:")
            stateManager.textures.append(texture)
        }
        if let texture = try? TextureResource.load(named: "Captcha2Wrong") {
            //  print("texture2Wrong found:")
            stateManager.textures.append(texture)
        }
        if let texture = try? TextureResource.load(named: "Captcha3") {
            //  print("texture3 found:")
            stateManager.textures.append(texture)
        }
        if let texture = try? TextureResource.load(named: "Captcha3Wrong") {
            //  print("texture3Wrong found:")
            stateManager.textures.append(texture)
        }
        if let texture = try? TextureResource.load(named: "Captcha4") {
            // print("texture4 found:")
            stateManager.textures.append(texture)
        }
        if let texture = try? TextureResource.load(named: "Captcha4Wrong") {
            //            print("texture4Wrong found:")
            stateManager.textures.append(texture)
        }
        if let texture = try? TextureResource.load(named: "Captcha5") {
            //            print("texture5 found:")
            stateManager.textures.append(texture)
        }
        if let texture = try? TextureResource.load(named: "Captcha5Wrong") {
            //            print("texture5Wrong found:")
            stateManager.textures.append(texture)
        }
    }
    
}
