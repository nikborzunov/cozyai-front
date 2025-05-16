// src/RoomScanner/RoomScannerContainer.tsx

import React, { useRef, useEffect } from 'react';
import { View, StyleSheet, NativeSyntheticEvent } from 'react-native';
import { RoomScanner, RoomScannerHandle } from './RoomScannerView';
import ExitButton from '../components/ExitButton';

type Props = {
  isDarkMode: boolean;
  onExit: () => void;
  onMeshUpdate?: (vertices: number[]) => void;
  onRefReady?: (ref: React.MutableRefObject<RoomScannerHandle | null>) => void;
};

type MeshUpdateEvent = {
  vertices: number[];
};

const RoomScannerContainer: React.FC<Props> = ({
  isDarkMode,
  onExit,
  onMeshUpdate,
  onRefReady,
}) => {
  const scannerRef = useRef<RoomScannerHandle | null>(null);

  useEffect(() => {
    if (onRefReady) {
      onRefReady(scannerRef);
    }
  }, [onRefReady]);

  const handleMeshUpdate = (event: NativeSyntheticEvent<MeshUpdateEvent>) => {
    const vertices = event.nativeEvent.vertices;
    console.log('Received mesh vertices:', vertices);
    onMeshUpdate?.(vertices);
  };

  return (
    <View style={styles.arContainer}>
      <RoomScanner
        ref={scannerRef}
        style={styles.arView}
        onMeshUpdate={handleMeshUpdate}
      />
      <ExitButton isDarkMode={isDarkMode} onExit={onExit} />
    </View>
  );
};

const styles = StyleSheet.create({
  arContainer: {
    ...StyleSheet.absoluteFillObject,
    bottom: 60,
  },
  arView: {
    flex: 1,
  },
});

export default RoomScannerContainer;
