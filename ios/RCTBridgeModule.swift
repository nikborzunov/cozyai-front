//
//  RCTBridgeModule.swift
//  CozyAI
//
//  Created by God of Code on 5/13/25.
//

import Foundation
import React

@objc(SimpleModule)
class SimpleModule: NSObject {
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return false
  }

  @objc
  func greet(_ name: NSString, resolver: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
    let message = "Привет, \(name)!"
    resolver(message)
  }
}
