//
//  SimpleModule.swift
//  CozyAI
//
//  Created by God of Code on 5/13/25.
//

import Foundation
import React

@objc(SimpleModule)
class SimpleModule: NSObject {
  @objc
  func greet(_ name: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let message = "Привет, \(name)!"
    resolve(message)
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return false
  }
}
