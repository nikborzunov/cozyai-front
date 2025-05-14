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
class RoomScannerView: UIView, ARSCNViewDelegate {
  private var sceneView: ARSCNView!
  @objc var onReady: RCTDirectEventBlock?

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
    guard anchor is ARMeshAnchor else { return }

    DispatchQueue.main.async {
      if let onReady = self.onReady {
        onReady(["message": "AR Ready"])
      }
    }
  }
}
