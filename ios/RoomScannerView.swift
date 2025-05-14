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
    guard let meshAnchor = anchor as? ARMeshAnchor else { return }
    print("Меш-объект добавлен: \(meshAnchor)")
  }
}
