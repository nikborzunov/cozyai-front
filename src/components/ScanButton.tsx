// src/components/ScanButton.tsx

import React from 'react';
import { TouchableOpacity, Text, Animated, StyleSheet } from 'react-native';

type Props = {
  isDarkMode: boolean;
  isScanning: boolean;
  toggleScanning: () => void;
  scale: Animated.Value;
};

const ScanButton = ({ isDarkMode, isScanning, toggleScanning, scale }: Props) => (
  <Animated.View style={{ transform: [{ scale }] }}>
    <TouchableOpacity
      style={[styles.button, { backgroundColor: isDarkMode ? '#4CAF50' : '#007bff' }]}
      onPress={toggleScanning}
    >
      <Text style={styles.text}>{isScanning ? 'Stop Scanning' : 'Start Scanning'}</Text>
    </TouchableOpacity>
  </Animated.View>
);

const styles = StyleSheet.create({
  button: {
    paddingVertical: 15, paddingHorizontal: 40, borderRadius: 50,
    marginBottom: 20, shadowColor: '#000', shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15, shadowRadius: 4, elevation: 5,
  },
  text: {
    fontSize: 18, color: '#fff', fontWeight: '600', textAlign: 'center', fontFamily: 'Roboto',
  },
});

export default ScanButton;
