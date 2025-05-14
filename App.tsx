// App.tsx

import React, { useState, useMemo, useCallback, useEffect } from 'react';
import { View, StyleSheet, StatusBar, useColorScheme, Animated, Vibration } from 'react-native';
import Header from './src/components/Header';
import Description from './src/components/Description';
import ScanButton from './src/components/ScanButton';
import GreetButton from './src/components/GreetButton';
import StatusMessage from './src/components/StatusMessage';
import ExitButton from './src/components/ExitButton';
import RoomScannerContainer from './src/RoomScanner/RoomScannerContainer';

const App = (): React.JSX.Element => {
  const isDarkMode = useColorScheme() === 'dark';
  const [isScanning, setIsScanning] = useState(false);
  const [showARView, setShowARView] = useState(false);
  const [loading, setLoading] = useState(false);

  const buttonScale = useMemo(() => new Animated.Value(1), []);

  const toggleScanning = useCallback(() => {
    setIsScanning((prev) => !prev);
    setShowARView((prev) => !prev);
    setLoading(true);
    Vibration.vibrate(100);

    Animated.sequence([
      Animated.spring(buttonScale, { toValue: 1.1, useNativeDriver: true }),
      Animated.spring(buttonScale, { toValue: 1, useNativeDriver: true }),
    ]).start();
  }, [buttonScale]);

  const exitAR = useCallback(() => {
    setShowARView(false);
    setIsScanning(false);
    setLoading(false);
  }, []);

  const backgroundStyle = {
    backgroundColor: isDarkMode ? '#121212' : '#F7F7F7',
  };

  useEffect(() => {
    if (isScanning && showARView) setLoading(true);
  }, [isScanning, showARView]);

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
        <GreetButton isDarkMode={isDarkMode} />
        <StatusMessage isDarkMode={isDarkMode} isScanning={isScanning} loading={loading} />
      </View>

      <RoomScannerContainer
        showARView={showARView}
        loading={loading}
        isDarkMode={isDarkMode}
        onARReady={() => setLoading(false)}
        onExit={exitAR}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1, justifyContent: 'flex-start', alignItems: 'center',
    paddingTop: 80, paddingHorizontal: 20,
  },
  bodyContainer: {
    justifyContent: 'center', alignItems: 'center',
    paddingHorizontal: 20, width: '100%',
  },
});

export default App;
