import React, { useState } from 'react';
import { View, Text, StyleSheet, StatusBar, useColorScheme, TouchableOpacity, Animated, Vibration } from 'react-native';

const App = (): React.JSX.Element => {
  const isDarkMode = useColorScheme() === 'dark';
  const [isScanning, setIsScanning] = useState(false);

  const buttonScale = new Animated.Value(1);

  const toggleScanning = () => {
    setIsScanning(!isScanning);
    Vibration.vibrate(100);

    Animated.sequence([
      Animated.spring(buttonScale, {
        toValue: 1.1,
        useNativeDriver: true,
      }),
      Animated.spring(buttonScale, {
        toValue: 1,
        useNativeDriver: true,
      }),
    ]).start();
  };

  const backgroundStyle = {
    backgroundColor: isDarkMode ? '#121212' : '#F7F7F7',
  };

  return (
    <View style={[styles.container, backgroundStyle]}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <View style={styles.headerContainer}>
        <Text style={[styles.headerText, { color: isDarkMode ? '#F7F7F7' : '#333' }]}>
          Умный дизайнер интерьера
        </Text>
      </View>
      <View style={styles.bodyContainer}>
        <Text style={[styles.descriptionText, { color: isDarkMode ? '#D1D1D1' : '#333' }]}>
          Начните сканировать ваше помещение для получения индивидуального плана расстановки мебели.
        </Text>

        <Animated.View style={{ transform: [{ scale: buttonScale }] }}>
          <TouchableOpacity
            style={[styles.button, { backgroundColor: isDarkMode ? '#4CAF50' : '#007bff' }]}
            onPress={toggleScanning}>
            <Text style={styles.buttonText}>
              {isScanning ? 'Остановить сканирование' : 'Начать сканирование'}
            </Text>
          </TouchableOpacity>
        </Animated.View>

        {isScanning && (
          <Text style={[styles.statusText, { color: isDarkMode ? '#BDBDBD' : '#666' }]}>
            Сканирование... Пожалуйста, подождите.
          </Text>
        )}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  headerContainer: {
    marginBottom: 40,
  },
  headerText: {
    fontSize: 32,
    fontWeight: '700',
    fontFamily: 'Roboto',
    textAlign: 'center',
  },
  bodyContainer: {
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
    width: '100%',
  },
  descriptionText: {
    fontSize: 18,
    textAlign: 'center',
    marginBottom: 30,
    fontFamily: 'Roboto',
  },
  button: {
    backgroundColor: '#007bff',
    paddingVertical: 15,
    paddingHorizontal: 40,
    borderRadius: 50,
    marginBottom: 20,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 4,
    elevation: 5,
  },
  buttonText: {
    fontSize: 18,
    color: '#fff',
    fontWeight: '600',
    textAlign: 'center',
    fontFamily: 'Roboto',
  },
  statusText: {
    fontSize: 16,
    textAlign: 'center',
    marginTop: 10,
    fontFamily: 'Roboto',
  },
});

export default App;
