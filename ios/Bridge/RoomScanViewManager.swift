//
//  RoomScanViewManager.swift
//  CozyAI
//
//  Created by God of Code on 5/14/25.
//

import Foundation
import React

@objc(RoomScanViewManager)
class RoomScanViewManager: RCTViewManager {
    override func view() -> UIView! {
        return RoomScanView()
    }

    override static func requiresMainQueueSetup() -> Bool {
        return true
    }

    @objc func startSession(_ reactTag: NSNumber) {
        bridge.uiManager.addUIBlock { (uiManager, viewRegistry) in
            guard let view = viewRegistry?[reactTag] as? RoomScanView else { return }
            view.startSession()
        }
    }

    @objc func stopSession(_ reactTag: NSNumber) {
        bridge.uiManager.addUIBlock { (uiManager, viewRegistry) in
            guard let view = viewRegistry?[reactTag] as? RoomScanView else { return }
            view.stopSession()
        }
    }
}
