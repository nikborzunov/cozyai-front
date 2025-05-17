//
//  ARSessionManager.swift
//  CozyAI
//
//  Created by God of Code on 5/17/25.
//

import ARKit

class ARSessionManager {
    private let sceneView: ARSCNView
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }
    
    func startSession() {
        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else { return }
        
        let config = ARWorldTrackingConfiguration()
        config.sceneReconstruction = .mesh
        config.environmentTexturing = .automatic
        config.planeDetection = [.vertical]
        
        sceneView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func stopSession() {
        sceneView.session.pause()
    }
    
    func setupScene() {
        sceneView.scene = SCNScene()
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
    }
}
