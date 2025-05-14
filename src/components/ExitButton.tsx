// src/components/ExitButton.tsx

import React from 'react';
import { TouchableOpacity, Text, StyleSheet } from 'react-native';

const ExitButton = ({
  isDarkMode,
  onExit,
}: {
  isDarkMode: boolean;
  onExit: () => void;
}) => (
  <TouchableOpacity
    style={[styles.button, { backgroundColor: isDarkMode ? '#F44336' : '#dc3545' }]}
    onPress={onExit}
  >
    <Text style={styles.text}>Exit AR</Text>
  </TouchableOpacity>
);

const styles = StyleSheet.create({
  button: {
    position: 'absolute', bottom: 20, alignSelf: 'center',
    paddingVertical: 15, paddingHorizontal: 40, borderRadius: 50,
    marginBottom: 20, shadowColor: '#000', shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15, shadowRadius: 4, elevation: 5,
  },
  text: {
    fontSize: 18, color: '#fff', fontWeight: '600', textAlign: 'center', fontFamily: 'Roboto',
  },
});

export default ExitButton;
