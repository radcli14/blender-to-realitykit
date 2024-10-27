//
//  ContentView.swift
//  BlenderToRealityKitIPhone
//
//  Created by Eliott Radcliffe on 10/27/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        RealityView { content in
            // Sets the RealityView to place the scene content in the real world view
            content.camera = .spatialTracking
            
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "Scene")  { //}, in: realityKitContentBundle) { // TODO: why does this throw an error on iOS?
                content.add(scene)
                
                // Shring the Blender object by half and move it in front of the camera to be visible in the iPhone camera
                scene.transform.scale = [0.5, 0.5, 0.5]
                scene.transform.translation.z = -1
                
                scene.availableAnimations.forEach { animation in
                    scene.playAnimation(animation.repeat(duration: .infinity))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
