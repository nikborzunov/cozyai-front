//
//  RoomScannerViewManager.m
//  CozyAI
//
//  Created by God of Code on 5/14/25.
//

#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(RoomScannerViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(onReady, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMeshUpdate, RCTDirectEventBlock)

@end
