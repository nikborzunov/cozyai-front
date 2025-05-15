//
//  RoomScannerView.swift
//  CozyAI
//
//  Created by God of Code on 5/14/25.
//

import Foundation
import ARKit
import React

@objc(RoomScannerView)
class RoomScannerView: UIView, ARSCNViewDelegate, ARSessionDelegate {
  private var sceneView: ARSCNView!
  @objc var onReady: RCTDirectEventBlock?
  @objc var onMeshUpdate: RCTDirectEventBlock?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSceneView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupSceneView()
  }

  private func setupSceneView() {
    sceneView = ARSCNView(frame: self.bounds)
    sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    sceneView.delegate = self
    sceneView.session.delegate = self
    sceneView.scene = SCNScene()
    self.addSubview(sceneView)

    if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
      let config = ARWorldTrackingConfiguration()
      config.sceneReconstruction = .mesh
      config.environmentTexturing = .automatic
      config.planeDetection = [.horizontal, .vertical]
      sceneView.session.run(config)
    }
  }

  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    if let planeAnchor = anchor as? ARPlaneAnchor {
      if planeAnchor.alignment == .vertical {
        let highlightNode = createHighlightNode(for: planeAnchor)
        node.addChildNode(highlightNode)
      }
    }

    if anchor is ARMeshAnchor {
      DispatchQueue.main.async {
        self.onReady?(["message": "AR Ready"])
      }
    }
  }

  func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    for anchor in anchors {
      if let planeAnchor = anchor as? ARPlaneAnchor {
        if planeAnchor.alignment == .vertical {
          updateHighlightNode(for: planeAnchor)
        }
      }

      guard let meshAnchor = anchor as? ARMeshAnchor else { continue }
      let geometry = meshAnchor.geometry
      let json = convertMeshToJSON(mesh: geometry)
      DispatchQueue.main.async {
        self.onMeshUpdate?(json)
      }
    }
  }

  private func createHighlightNode(for planeAnchor: ARPlaneAnchor) -> SCNNode {
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)

    let planeGeometry = SCNPlane(width: width, height: height)
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.systemBlue.withAlphaComponent(0.4)
    material.isDoubleSided = true
    planeGeometry.materials = [material]

    let planeNode = SCNNode(geometry: planeGeometry)
    planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
    planeNode.eulerAngles.x = -.pi / 2  // Повернуть плоскость вертикально (ARKit плоскости по умолчанию горизонтальны)

    planeNode.name = planeAnchor.identifier.uuidString

    return planeNode
  }

  private func updateHighlightNode(for planeAnchor: ARPlaneAnchor) {
    guard let node = sceneView.node(for: planeAnchor) else { return }
    guard let planeNode = node.childNodes.first(where: { $0.name == planeAnchor.identifier.uuidString }) else { return }
    guard let planeGeometry = planeNode.geometry as? SCNPlane else { return }

    planeGeometry.width = CGFloat(planeAnchor.extent.x)
    planeGeometry.height = CGFloat(planeAnchor.extent.z)

    planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
  }

  private func convertMeshToJSON(mesh: ARMeshGeometry) -> [String: Any] {
    var vertices: [[Float]] = []

    let vertexCount = mesh.vertices.count
    let vertexBuffer = mesh.vertices.buffer
    let vertexOffset = mesh.vertices.offset
    let vertexStride = mesh.vertices.stride

    let rawPointer = vertexBuffer.contents()
    for i in 0..<vertexCount {
      let pointer = rawPointer.advanced(by: vertexOffset + i * vertexStride)
      let float3Pointer = pointer.bindMemory(to: simd_float3.self, capacity: 1)
      let vertex = float3Pointer.pointee
      vertices.append([vertex.x, vertex.y, vertex.z])
    }

    return ["vertices": vertices]
  }
}
