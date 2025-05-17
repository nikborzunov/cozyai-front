//
//  RoomScannerView.swift
//  CozyAI
//
//  Created by God of Code on 5/14/25.
//

// RoomScannerView.swift
import Foundation
import ARKit
import SceneKit
import React

class RoomScannerView: UIView, ARSCNViewDelegate, ARSessionDelegate {
  private var sceneView: ARSCNView!
  @objc var onReady: RCTDirectEventBlock?
  @objc var onMeshUpdate: RCTDirectEventBlock?

  private var fixedPlanes = Set<String>()
  private var lastMeshUpdateTime: TimeInterval = 0

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSceneView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupSceneView()
  }

  @objc func startSession() {
    guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else { return }

    let config = ARWorldTrackingConfiguration()
    config.sceneReconstruction = .mesh
    config.environmentTexturing = .automatic
    config.planeDetection = [.vertical]

    sceneView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
  }

  @objc func stopSession() {
    sceneView.session.pause()
  }

  private func setupSceneView() {
    sceneView = ARSCNView(frame: bounds)
    sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    sceneView.delegate = self
    sceneView.session.delegate = self
    sceneView.scene = SCNScene()
    addSubview(sceneView)

    if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
      let config = ARWorldTrackingConfiguration()
      config.sceneReconstruction = .mesh
      config.environmentTexturing = .automatic
      config.planeDetection = [.vertical]
      sceneView.session.run(config)
    }
  }

  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    if let planeAnchor = anchor as? ARPlaneAnchor, isValidVerticalPlane(planeAnchor) {
      if fixedPlanes.contains(planeAnchor.identifier.uuidString) { return }
      let highlight = PlaneHighlighter.createHighlightNode(for: planeAnchor)
      node.addChildNode(highlight)
    }

    if anchor is ARMeshAnchor {
      DispatchQueue.main.async {
        self.onReady?(["message": "AR Ready"])
      }
    }
  }

  func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    let now = Date().timeIntervalSince1970

    for anchor in anchors {
      if let planeAnchor = anchor as? ARPlaneAnchor, isValidVerticalPlane(planeAnchor) {
        if !fixedPlanes.contains(planeAnchor.identifier.uuidString) {
          PlaneHighlighter.updateHighlightNode(for: planeAnchor, in: sceneView)
        }
      }

      if let meshAnchor = anchor as? ARMeshAnchor, now - lastMeshUpdateTime > 0.5 {
        lastMeshUpdateTime = now
        let json = MeshProcessor.convertMeshToJSON(mesh: meshAnchor.geometry)
        DispatchQueue.main.async {
          self.onMeshUpdate?(json)
        }
      }
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: sceneView)
    let hits = sceneView.hitTest(location, options: nil)

    for hit in hits {
      guard let name = hit.node.name, name.starts(with: "tapCircle_") else { continue }
      let id = String(name.dropFirst("tapCircle_".count))
      guard let parent = hit.node.parent else { continue }
      fixPlane(id: id, node: parent)
      break
    }
  }

  private func fixPlane(id: String, node: SCNNode) {
    guard !fixedPlanes.contains(id) else { return }
    let clone = node.clone()
    clone.name = "fixed_\(id)"
    sceneView.scene.rootNode.addChildNode(clone)
    fixedPlanes.insert(id)
  }

  private func isValidVerticalPlane(_ anchor: ARPlaneAnchor) -> Bool {
    return anchor.alignment == .vertical && (anchor.extent.x * anchor.extent.z) >= 0.05
  }
}
