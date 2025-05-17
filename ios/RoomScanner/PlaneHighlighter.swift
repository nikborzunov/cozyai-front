//
//  PlaneHighlighter.swift
//  CozyAI
//
//  Created by God of Code on 5/16/25.
//

// PlaneHighlighter.swift
import ARKit
import SceneKit
import UIKit

class PlaneHighlighter {
  static func createHighlightNode(for anchor: ARPlaneAnchor) -> SCNNode {
    let size = CGSize(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
    let planeGeometry = SCNPlane(width: size.width, height: size.height)
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.systemGreen.withAlphaComponent(0.3)
    material.isDoubleSided = true
    planeGeometry.materials = [material]

    let planeNode = SCNNode(geometry: planeGeometry)
    planeNode.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
    planeNode.eulerAngles.x = -.pi / 2
    planeNode.name = anchor.identifier.uuidString

    let iconGeometry = SCNPlane(width: 0.1, height: 0.1)
    let iconMaterial = SCNMaterial()
    iconMaterial.diffuse.contents = UIImage(systemName: "plus.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) ?? UIColor.systemGreen
    iconMaterial.isDoubleSided = true
    iconMaterial.readsFromDepthBuffer = false
    iconMaterial.writesToDepthBuffer = false
    iconGeometry.materials = [iconMaterial]

    let iconNode = SCNNode(geometry: iconGeometry)
    iconNode.position = SCNVector3(0, 0.01, 0)
    iconNode.renderingOrder = 1000
    iconNode.name = "tapCircle_\(anchor.identifier.uuidString)"

    planeNode.addChildNode(iconNode)
    return planeNode
  }

  static func updateHighlightNode(for anchor: ARPlaneAnchor, in sceneView: ARSCNView) {
    guard
      let node = sceneView.node(for: anchor),
      let planeNode = node.childNodes.first(where: { $0.name == anchor.identifier.uuidString }),
      let planeGeometry = planeNode.geometry as? SCNPlane
    else { return }

    planeGeometry.width = CGFloat(anchor.extent.x)
    planeGeometry.height = CGFloat(anchor.extent.z)
    planeNode.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)

    if let iconNode = planeNode.childNodes.first(where: { $0.name == "tapCircle_\(anchor.identifier.uuidString)" }) {
      iconNode.position = SCNVector3(0, 0.01, 0)
    }
  }
}
