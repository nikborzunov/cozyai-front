//
//  RoomScanView.swift
//  CozyAI
//
//  Created by God of Code on 5/14/25.
//

// RoomScanView.swift
import UIKit
import React
import ARKit
import SceneKit

class RoomScanView: UIView, ARSCNViewDelegate, ARSessionDelegate {
    private var sceneView: ARSCNView!
    private let sessionManager: ARSessionManager
    private let surfaceVisualizer: SurfaceVisualizer
    private let meshStreamer: MeshDataStreamer
    
    @objc var onReady: RCTDirectEventBlock?
    @objc var onMeshUpdate: RCTDirectEventBlock?
    
    override init(frame: CGRect) {
        sceneView = ARSCNView(frame: frame)
        sessionManager = ARSessionManager(sceneView: sceneView)
        surfaceVisualizer = SurfaceVisualizer(sceneView: sceneView)
        meshStreamer = MeshDataStreamer()
        super.init(frame: frame)
        setupView()
        startSession()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sceneView.delegate = self
        sceneView.session.delegate = self
        addSubview(sceneView)
        sessionManager.setupScene()
        
        meshStreamer.onMeshUpdate = { [weak self] json in
            DispatchQueue.main.async {
                self?.onMeshUpdate?(json)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sceneView.frame = bounds
    }
    
    @objc func startSession() {
        sessionManager.startSession()
    }
    
    @objc func stopSession() {
        sessionManager.stopSession()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            surfaceVisualizer.handleSurfaceAdded(planeAnchor, node: node)
        }
        if anchor is ARMeshAnchor {
            DispatchQueue.main.async {
                self.onReady?(["message": "AR Ready"])
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        anchors.forEach {
            if let planeAnchor = $0 as? ARPlaneAnchor {
                surfaceVisualizer.handleSurfaceUpdated(planeAnchor)
            }
            if let meshAnchor = $0 as? ARMeshAnchor {
                meshStreamer.handleMeshUpdate(meshAnchor)
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
            surfaceVisualizer.fixSurface(id: id, node: parent)
            break
        }
    }
}
