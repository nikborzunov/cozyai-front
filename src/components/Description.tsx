// src/components/Description.tsx

import React from 'react';
import { Text, StyleSheet } from 'react-native';

const Description = ({ isDarkMode }: { isDarkMode: boolean }) => (
  <Text style={[styles.text, { color: isDarkMode ? '#D1D1D1' : '#333' }]}>
    Start scanning your room to get a personalized furniture arrangement plan.
  </Text>
);

const styles = StyleSheet.create({
  text: {
    fontSize: 18, textAlign: 'center', marginBottom: 30, fontFamily: 'Roboto',
  },
});

export default Description;
