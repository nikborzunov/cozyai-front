//
//  SurfaceHighlighter.swift
//  CozyAI
//
//  Created by God of Code on 5/16/25.
//

// SurfaceHighlighter.swift
import ARKit
import SceneKit
import UIKit

class SurfaceHighlighter {
    static func createHighlight(for anchor: ARPlaneAnchor) -> SCNNode {
        let size = CGSize(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let geometry = SCNPlane(width: size.width, height: size.height)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemGreen.withAlphaComponent(0.3)
        material.isDoubleSided = true
        geometry.materials = [material]

        let node = SCNNode(geometry: geometry)
        node.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        node.eulerAngles.x = -.pi / 2
        node.name = anchor.identifier.uuidString

        let iconGeometry = SCNPlane(width: 0.1, height: 0.1)
        let iconMaterial = SCNMaterial()
        iconMaterial.diffuse.contents = UIImage(systemName: "plus.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) ?? UIColor.systemGreen
        iconMaterial.isDoubleSided = true
        iconGeometry.materials = [iconMaterial]

        let iconNode = SCNNode(geometry: iconGeometry)
        iconNode.position = SCNVector3(0, 0.01, 0)
        iconNode.renderingOrder = 1000
        iconNode.name = "tapCircle_\(anchor.identifier.uuidString)"

        node.addChildNode(iconNode)
        return node
    }

    static func updateHighlight(for anchor: ARPlaneAnchor, in sceneView: ARSCNView) {
        guard let node = sceneView.node(for: anchor),
              let surfaceNode = node.childNodes.first(where: { $0.name == anchor.identifier.uuidString }),
              let geometry = surfaceNode.geometry as? SCNPlane else { return }

        geometry.width = CGFloat(anchor.extent.x)
        geometry.height = CGFloat(anchor.extent.z)
        surfaceNode.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)

        if let iconNode = surfaceNode.childNodes.first(where: { $0.name == "tapCircle_\(anchor.identifier.uuidString)" }) {
            iconNode.position = SCNVector3(0, 0.01, 0)
        }
    }
}
