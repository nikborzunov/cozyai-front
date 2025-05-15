// src/RoomScanner/RoomScannerView.tsx

import {
  requireNativeComponent,
  ViewStyle,
  findNodeHandle,
  NativeEventEmitter,
  NativeModules,
} from 'react-native';
import React, { forwardRef, useImperativeHandle, useRef, useEffect } from 'react';

const { RoomScannerViewManager } = NativeModules;

type NativeProps = {
  style?: ViewStyle;
  onReady?: () => void;
  onMeshUpdate?: (event: { nativeEvent: any }) => void;
};

const COMPONENT_NAME = 'RoomScannerView';
const RoomScannerView = requireNativeComponent<NativeProps>(COMPONENT_NAME);

export const RoomScanner = forwardRef((props: NativeProps, ref) => {
  const viewRef = useRef(null);

  useImperativeHandle(ref, () => ({
    getNativeHandle: () => findNodeHandle(viewRef.current),
  }));

  useEffect(() => {
    const eventEmitter = new NativeEventEmitter(RoomScannerViewManager);
    let subscriptions: any[] = [];

    if (props.onReady) {
      subscriptions.push(
        eventEmitter.addListener('onReady', props.onReady)
      );
    }

    if (props.onMeshUpdate) {
      subscriptions.push(
        eventEmitter.addListener('onMeshUpdate', props.onMeshUpdate)
      );
    }

    return () => {
      subscriptions.forEach((sub) => sub.remove());
    };
  }, [props.onReady, props.onMeshUpdate]);

  return <RoomScannerView ref={viewRef} {...props} />;
});
