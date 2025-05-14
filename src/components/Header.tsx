// src/components/Header.tsx

import React from 'react';
import { Text, View, StyleSheet } from 'react-native';

const Header = ({ isDarkMode }: { isDarkMode: boolean }) => (
  <View style={styles.container}>
    <Text style={[styles.text, { color: isDarkMode ? '#F7F7F7' : '#333' }]}>
      Smart Interior Designer
    </Text>
  </View>
);

const styles = StyleSheet.create({
  container: { marginBottom: 40 },
  text: { fontSize: 32, fontWeight: '700', fontFamily: 'Roboto', textAlign: 'center' },
});

export default Header;
