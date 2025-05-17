// src/RoomScanner/RoomScannerView.tsx

import React, {
  forwardRef,
  useImperativeHandle,
  useRef,
  Ref,
} from 'react';
import {
  requireNativeComponent,
  findNodeHandle,
  UIManager,
  ViewStyle,
  NativeSyntheticEvent,
} from 'react-native';

const COMPONENT_NAME = 'RoomScanView';

type MeshUpdateEvent = {
  vertices: number[];
};

type RoomScannerViewProps = {
  style?: ViewStyle;
  onMeshUpdate?: (event: NativeSyntheticEvent<MeshUpdateEvent>) => void;
};

export type RoomScannerHandle = {
  start: () => void;
  stop: () => void;
  getNativeHandle: () => number | null;
};

const NativeRoomScannerView = requireNativeComponent<RoomScannerViewProps>(COMPONENT_NAME);

export const RoomScanner = forwardRef((props: RoomScannerViewProps, ref: Ref<RoomScannerHandle>) => {
  const viewRef = useRef(null);

  useImperativeHandle(ref, (): RoomScannerHandle => ({
    start: () => {
      const viewId = findNodeHandle(viewRef.current);
      if (viewId) {
        UIManager.dispatchViewManagerCommand(
          viewId,
          UIManager.getViewManagerConfig(COMPONENT_NAME).Commands?.startSession ?? 0,
          [],
        );
      }
    },
    stop: () => {
      const viewId = findNodeHandle(viewRef.current);
      if (viewId) {
        UIManager.dispatchViewManagerCommand(
          viewId,
          UIManager.getViewManagerConfig(COMPONENT_NAME).Commands?.stopSession ?? 1,
          [],
        );
      }
    },
    getNativeHandle: () => findNodeHandle(viewRef.current),
  }));

  return <NativeRoomScannerView ref={viewRef} {...props} />;
});
