//
//  SurfaceVisualizer.swift
//  CozyAI
//
//  Created by God of Code on 5/17/25.
//

import ARKit
import SceneKit

class SurfaceVisualizer {
    private var fixedSurfaces = Set<String>()
    private weak var sceneView: ARSCNView?
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }
    
    func handleSurfaceAdded(_ anchor: ARPlaneAnchor, node: SCNNode) {
        guard isValidVerticalSurface(anchor), !fixedSurfaces.contains(anchor.identifier.uuidString) else { return }
        let highlight = SurfaceHighlighter.createHighlight(for: anchor)
        node.addChildNode(highlight)
    }
    
    func handleSurfaceUpdated(_ anchor: ARPlaneAnchor) {
        guard isValidVerticalSurface(anchor), !fixedSurfaces.contains(anchor.identifier.uuidString), let sceneView = sceneView else { return }
        SurfaceHighlighter.updateHighlight(for: anchor, in: sceneView)
    }
    
    func fixSurface(id: String, node: SCNNode) {
        guard !fixedSurfaces.contains(id), let sceneView = sceneView else { return }
        let clone = node.clone()
        clone.name = "fixed_\(id)"
        sceneView.scene.rootNode.addChildNode(clone)
        fixedSurfaces.insert(id)
    }
    
    private func isValidVerticalSurface(_ anchor: ARPlaneAnchor) -> Bool {
        anchor.alignment == .vertical && (anchor.extent.x * anchor.extent.z) >= 0.05
    }
}
