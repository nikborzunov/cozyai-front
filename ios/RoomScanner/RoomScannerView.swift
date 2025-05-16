//
//  RoomScannerView.swift
//  CozyAI
//
//  Created by God of Code on 5/14/25.
//

// RoomScannerView.swift
import Foundation
import ARKit
import React
import SceneKit

class RoomScannerView: UIView, ARSCNViewDelegate, ARSessionDelegate {
  private var sceneView: ARSCNView!
  @objc var onReady: RCTDirectEventBlock?
  @objc var onMeshUpdate: RCTDirectEventBlock?
  
  private var fixedPlanes: Set<String> = []
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
      config.planeDetection = [.vertical]
      sceneView.session.run(config)
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    if let planeAnchor = anchor as? ARPlaneAnchor,
       planeAnchor.alignment == .vertical {
      if fixedPlanes.contains(planeAnchor.identifier.uuidString) { return }
      if planeAnchor.extent.x * planeAnchor.extent.z < 0.05 { return }
      let highlightNode = PlaneHighlighter.createHighlightNode(for: planeAnchor)
      node.addChildNode(highlightNode)
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
      if let planeAnchor = anchor as? ARPlaneAnchor,
         planeAnchor.alignment == .vertical {
        if !fixedPlanes.contains(planeAnchor.identifier.uuidString) {
          if planeAnchor.extent.x * planeAnchor.extent.z < 0.05 { continue }
          PlaneHighlighter.updateHighlightNode(for: planeAnchor, in: sceneView)
        }
      }
      
      if let meshAnchor = anchor as? ARMeshAnchor,
         now - lastMeshUpdateTime > 0.5 {
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
    let hitResults = sceneView.hitTest(location, options: nil)
    
    for result in hitResults {
      guard let nodeName = result.node.name, nodeName.starts(with: "tapCircle_") else { continue }
      let planeId = String(nodeName.dropFirst("tapCircle_".count))
      guard let parent = result.node.parent else { continue }
      fixPlane(withIdentifier: planeId, sourceNode: parent)
      break
    }
  }
  
  private func fixPlane(withIdentifier identifier: String, sourceNode: SCNNode) {
    guard !fixedPlanes.contains(identifier) else { return }
    let clone = sourceNode.clone()
    clone.name = "fixed_\(identifier)"
    sceneView.scene.rootNode.addChildNode(clone)
    fixedPlanes.insert(identifier)
  }
}
