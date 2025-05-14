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
};

const COMPONENT_NAME = 'RoomScannerView';
const RoomScannerView = requireNativeComponent<NativeProps>(COMPONENT_NAME);

export const RoomScanner = forwardRef((props: NativeProps, ref) => {
  const viewRef = useRef(null);

  useImperativeHandle(ref, () => ({
    getNativeHandle: () => findNodeHandle(viewRef.current),
  }));

  useEffect(() => {
    if (props.onReady) {
      const eventEmitter = new NativeEventEmitter(RoomScannerViewManager);
      const subscription = eventEmitter.addListener('onReady', props.onReady);

      return () => {
        subscription.remove();
      };
    }
  }, [props.onReady]);

  return <RoomScannerView ref={viewRef} {...props} />;
});
