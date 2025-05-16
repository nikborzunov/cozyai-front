//
//  RoomScannerView.swift
//  CozyAI
//
//  Created by God of Code on 5/14/25.
//

import Foundation
import ARKit
import React
import SceneKit

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
  
  @objc func startSession() {
    guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else { return }

    let config = ARWorldTrackingConfiguration()
    config.sceneReconstruction = .mesh
    config.environmentTexturing = .automatic
    config.planeDetection = [.horizontal, .vertical]
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
      config.planeDetection = [.horizontal, .vertical]
      sceneView.session.run(config)
    }
  }

  // MARK: - ARSCNViewDelegate

  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    if let planeAnchor = anchor as? ARPlaneAnchor,
       planeAnchor.alignment == .vertical {
      let highlightNode = PlaneHighlighter.createHighlightNode(for: planeAnchor)
      node.addChildNode(highlightNode)
    }

    if anchor is ARMeshAnchor {
      DispatchQueue.main.async {
        self.onReady?(["message": "AR Ready"])
      }
    }
  }

  // MARK: - ARSessionDelegate

  func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    for anchor in anchors {
      if let planeAnchor = anchor as? ARPlaneAnchor,
         planeAnchor.alignment == .vertical {
        PlaneHighlighter.updateHighlightNode(for: planeAnchor, in: sceneView)
      }

      guard let meshAnchor = anchor as? ARMeshAnchor else { continue }
      let json = MeshProcessor.convertMeshToJSON(mesh: meshAnchor.geometry)
      DispatchQueue.main.async {
        self.onMeshUpdate?(json)
      }
    }
  }
}
