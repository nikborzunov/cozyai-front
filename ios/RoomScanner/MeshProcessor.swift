//
//  MeshProcessor.swift
//  CozyAI
//
//  Created by God of Code on 5/16/25.
//

// MeshProcessor.swift
import ARKit

class MeshProcessor {
  static func convertMeshToJSON(mesh: ARMeshGeometry) -> [String: Any] {
    guard mesh.vertices.count > 0 else { return [:] }

    var vertices: [[Float]] = []
    let buffer = mesh.vertices.buffer
    let offset = mesh.vertices.offset
    let stride = mesh.vertices.stride
    let pointer = buffer.contents()

    for i in 0..<mesh.vertices.count {
      let vertexPointer = pointer.advanced(by: offset + i * stride).bindMemory(to: simd_float3.self, capacity: 1)
      let v = vertexPointer.pointee
      vertices.append([v.x, v.y, v.z])
    }

    return ["vertices": vertices]
  }
}
