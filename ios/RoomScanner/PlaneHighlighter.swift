//
//  PlaneHighlighter.swift
//  CozyAI
//
//  Created by God of Code on 5/16/25.
//

import ARKit
import SceneKit

class PlaneHighlighter {
  static func createHighlightNode(for planeAnchor: ARPlaneAnchor) -> SCNNode {
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)

    let planeGeometry = SCNPlane(width: width, height: height)
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.systemBlue.withAlphaComponent(0.4)
    material.isDoubleSided = true
    planeGeometry.materials = [material]

    let planeNode = SCNNode(geometry: planeGeometry)
    planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
    planeNode.eulerAngles.x = -.pi / 2
    planeNode.name = planeAnchor.identifier.uuidString

    return planeNode
  }

  static func updateHighlightNode(for planeAnchor: ARPlaneAnchor, in sceneView: ARSCNView) {
    guard let node = sceneView.node(for: planeAnchor),
          let planeNode = node.childNodes.first(where: { $0.name == planeAnchor.identifier.uuidString }),
          let planeGeometry = planeNode.geometry as? SCNPlane else { return }

    planeGeometry.width = CGFloat(planeAnchor.extent.x)
    planeGeometry.height = CGFloat(planeAnchor.extent.z)
    planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
  }
}
