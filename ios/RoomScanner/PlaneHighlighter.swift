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
  static func createHighlightNode(for planeAnchor: ARPlaneAnchor) -> SCNNode {
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    
    let planeGeometry = SCNPlane(width: width, height: height)
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.systemGreen.withAlphaComponent(0.3)
    material.isDoubleSided = true
    planeGeometry.materials = [material]
    
    let planeNode = SCNNode(geometry: planeGeometry)
    planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
    planeNode.eulerAngles.x = -.pi / 2
    planeNode.name = planeAnchor.identifier.uuidString
    
    let iconSize: CGFloat = 0.1
    let iconPlane = SCNPlane(width: iconSize, height: iconSize)
    
    let iconMaterial = SCNMaterial()
    if let image = UIImage(systemName: "plus.circle.fill") {
      iconMaterial.diffuse.contents = image.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    } else {
      iconMaterial.diffuse.contents = UIColor.systemGreen
    }
    iconMaterial.isDoubleSided = true
    iconPlane.materials = [iconMaterial]
    
    let iconNode = SCNNode(geometry: iconPlane)
    iconNode.eulerAngles.x = 0
    iconNode.position = SCNVector3(0, 0.001, 0)
    iconNode.name = "tapCircle_\(planeAnchor.identifier.uuidString)"
    
    planeNode.addChildNode(iconNode)
    
    return planeNode
  }
  
  static func updateHighlightNode(for planeAnchor: ARPlaneAnchor, in sceneView: ARSCNView) {
    guard
      let node = sceneView.node(for: planeAnchor),
      let planeNode = node.childNodes.first(where: { $0.name == planeAnchor.identifier.uuidString }),
      let planeGeometry = planeNode.geometry as? SCNPlane else { return }
    
    planeGeometry.width = CGFloat(planeAnchor.extent.x)
    planeGeometry.height = CGFloat(planeAnchor.extent.z)
    planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
    
    if let circleNode = planeNode.childNodes.first(where: { $0.name == "tapCircle_\(planeAnchor.identifier.uuidString)" }) {
      circleNode.position = SCNVector3(0, 0.001, 0)
    }
  }
}
