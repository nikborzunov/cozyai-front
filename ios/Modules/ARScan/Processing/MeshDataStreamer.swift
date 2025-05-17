//
//  MeshDataStreamer.swift
//  CozyAI
//
//  Created by God of Code on 5/17/25.
//

import ARKit

class MeshDataStreamer {
    var onMeshUpdate: (([String: Any]) -> Void)?
    private var lastUpdateTime: TimeInterval = 0
    
    func handleMeshUpdate(_ anchor: ARMeshAnchor) {
        let now = Date().timeIntervalSince1970
        guard now - lastUpdateTime > 0.5 else { return }
        lastUpdateTime = now
        let json = MeshDataConverter.convertToJSON(mesh: anchor.geometry)
        onMeshUpdate?(json)
    }
}
