// App.tsx

import React, { useState, useMemo, useCallback, useRef } from 'react';
import {
  View,
  StyleSheet,
  StatusBar,
  useColorScheme,
  Animated,
  Vibration,
  ActivityIndicator,
} from 'react-native';
import Header from './components/Header';
import Description from './components/Description';
import ScanButton from './components/ScanButton';
import StatusMessage from './components/StatusMessage';
import RoomScannerContainer from './RoomScanner/RoomScannerContainer';
import { RoomScannerHandle } from './RoomScanner/RoomScannerView';

const App: React.FC = () => {
  const isDarkMode = useColorScheme() === 'dark';
  const [isScanning, setIsScanning] = useState(false);
  const [showARView, setShowARView] = useState(false);
  const [loading, setLoading] = useState(false);

  const buttonScale = useMemo(() => new Animated.Value(1), []);
  const scannerRef = useRef<RoomScannerHandle | null>(null);

  const toggleScanning = useCallback(() => {
    if (!isScanning) {
      setShowARView(true);
      setLoading(true);

      setTimeout(() => {
        scannerRef.current?.start();
        setLoading(false);
      }, 1000);
    } else {
      scannerRef.current?.stop();
      setShowARView(false);
    }

    setIsScanning((prev) => !prev);
    Vibration.vibrate(100);

    Animated.sequence([
      Animated.spring(buttonScale, { toValue: 1.1, useNativeDriver: true }),
      Animated.spring(buttonScale, { toValue: 1, useNativeDriver: true }),
    ]).start();
  }, [isScanning, buttonScale]);

  const exitAR = useCallback(() => {
    scannerRef.current?.stop();
    setShowARView(false);
    setIsScanning(false);
    setLoading(false);
  }, []);

  const backgroundStyle = {
    backgroundColor: isDarkMode ? '#121212' : '#F7F7F7',
  };

  return (
    <View style={[styles.container, backgroundStyle]}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <Header isDarkMode={isDarkMode} />
      <View style={styles.bodyContainer}>
        <Description isDarkMode={isDarkMode} />
        <ScanButton
          isDarkMode={isDarkMode}
          isScanning={isScanning}
          toggleScanning={toggleScanning}
          scale={buttonScale}
        />
        <StatusMessage isDarkMode={isDarkMode} isScanning={isScanning} loading={loading} />
      </View>

      {showARView && (
        <>
          {loading && (
            <ActivityIndicator
              style={StyleSheet.absoluteFill}
              size="large"
              color={isDarkMode ? '#FFFFFF' : '#000000'}
            />
          )}
          <RoomScannerContainer
            isDarkMode={isDarkMode}
            onExit={exitAR}
            onRefReady={(ref) => {
              scannerRef.current = ref.current;
            }}
            onMeshUpdate={(vertices) => {
              console.log('Received mesh in App:', vertices);
            }}
          />
        </>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'flex-start',
    alignItems: 'center',
    paddingTop: 80,
    paddingHorizontal: 20,
  },
  bodyContainer: {
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
    width: '100%',
  },
});

export default App;
