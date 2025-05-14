// src/components/StatusMessage.tsx

import React from 'react';
import { Text, StyleSheet } from 'react-native';

const StatusMessage = ({
  isScanning,
  loading,
  isDarkMode,
}: {
  isScanning: boolean;
  loading: boolean;
  isDarkMode: boolean;
}) => {
  if (!isScanning || loading) return null;

  return (
    <Text style={[styles.text, { color: isDarkMode ? '#BDBDBD' : '#666' }]}>
      Scanning... Please wait.
    </Text>
  );
};

const styles = StyleSheet.create({
  text: {
    fontSize: 16, textAlign: 'center', marginTop: 10, fontFamily: 'Roboto',
  },
});

export default StatusMessage;
