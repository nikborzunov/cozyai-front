// src/RoomScanner/RoomScannerContainer.tsx

import React from 'react';
import { View, ActivityIndicator, StyleSheet } from 'react-native';
import { RoomScanner } from './RoomScannerView';
import ExitButton from '../components/ExitButton';

type Props = {
  showARView: boolean;
  loading: boolean;
  isDarkMode: boolean;
  onARReady: () => void;
  onExit: () => void;
};

const RoomScannerContainer = ({
  showARView,
  loading,
  isDarkMode,
  onARReady,
  onExit,
}: Props) => {
  if (!showARView) return null;

  return (
    <>
      <View style={styles.arContainer}>
        <RoomScanner style={styles.arView} onReady={onARReady} />
      </View>

      {loading ? (
        <ActivityIndicator size="large" color={isDarkMode ? '#FFFFFF' : '#000000'} />
      ) : (
        <ExitButton isDarkMode={isDarkMode} onExit={onExit} />
      )}
    </>
  );
};

const styles = StyleSheet.create({
  arContainer: {
    flex: 1, position: 'absolute', top: 0, left: 0, right: 0, bottom: 60,
  },
  arView: {
    flex: 1,
  },
});

export default RoomScannerContainer;
