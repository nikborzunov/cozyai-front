//
//  MeshProcessor.swift
//  CozyAI
//
//  Created by God of Code on 5/16/25.
//

import ARKit

class MeshProcessor {
  static func convertMeshToJSON(mesh: ARMeshGeometry) -> [String: Any] {
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
