//
//  SimpleModule.m
//  CozyAI
//
//  Created by God of Code on 5/13/25.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(SimpleModule, NSObject)
RCT_EXTERN_METHOD(greet:(NSString *)name
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
@end
