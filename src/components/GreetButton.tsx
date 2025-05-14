// src/components/GreetButton.tsx

import React, { useCallback } from 'react';
import { TouchableOpacity, Text, Alert, StyleSheet, NativeModules } from 'react-native';

const { SimpleModule } = NativeModules;

const GreetButton = ({ isDarkMode }: { isDarkMode: boolean }) => {
  const handleGreet = useCallback(async () => {
    try {
      const result = await SimpleModule.greet('user');
      Alert.alert('Swift response:', result);
    } catch (e) {
      Alert.alert('Error', (e as any).message || 'Failed to call module');
    }
  }, []);

  return (
    <TouchableOpacity
      style={[styles.button, { backgroundColor: isDarkMode ? '#607D8B' : '#6c757d' }]}
      onPress={handleGreet}
    >
      <Text style={styles.text}>Greet (Swift)</Text>
    </TouchableOpacity>
  );
};

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

export default GreetButton;
