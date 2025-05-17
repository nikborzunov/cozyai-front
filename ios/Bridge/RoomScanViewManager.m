//
//  RoomScanViewManager.m
//  CozyAI
//
//  Created by God of Code on 5/14/25.
//

#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(RoomScanViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(onReady, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMeshUpdate, RCTDirectEventBlock)

RCT_EXTERN_METHOD(startSession:(nonnull NSNumber *)reactTag)
RCT_EXTERN_METHOD(stopSession:(nonnull NSNumber *)reactTag)

@end
