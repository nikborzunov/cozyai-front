// RoomScannerView.tsx

import {
  requireNativeComponent,
  ViewStyle,
  findNodeHandle,
} from 'react-native';
import React, { forwardRef, useImperativeHandle, useRef } from 'react';

type NativeProps = {
  style?: ViewStyle;
};

const COMPONENT_NAME = 'RoomScannerView';

const RoomScannerView = requireNativeComponent<NativeProps>(COMPONENT_NAME);

export const RoomScanner = forwardRef((props: NativeProps, ref) => {
  const viewRef = useRef(null);

  useImperativeHandle(ref, () => ({
    getNativeHandle: () => findNodeHandle(viewRef.current),
  }));

  return <RoomScannerView ref={viewRef} {...props} />;
});
