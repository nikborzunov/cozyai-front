//
//  RoomScannerViewManager.swift
//  CozyAI
//
//  Created by God of Code on 5/14/25.
//

import Foundation
import React

@objc(RoomScannerViewManager)
class RoomScannerViewManager: RCTViewManager {
  override func view() -> UIView! {
    return RoomScannerView()
  }

  override static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc func startSession(_ reactTag: NSNumber) {
    bridge.uiManager.addUIBlock { (uiManager, viewRegistry) in
      guard let view = viewRegistry?[reactTag] as? RoomScannerView else { return }
      view.startSession()
    }
  }

  @objc func stopSession(_ reactTag: NSNumber) {
    bridge.uiManager.addUIBlock { (uiManager, viewRegistry) in
      guard let view = viewRegistry?[reactTag] as? RoomScannerView else { return }
      view.stopSession()
    }
  }
}
